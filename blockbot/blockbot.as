float round(float n, float d){
    float p = pow(10, d);
    return floor(n * p) / p;
}

float rad(float x)
{
return x * (3.14159265359f / 180.f);
}

float cap(float value, float min, float max)
{
    if (value > max)
        return max; 

    if (value < min)
        return min; 

    return value; 
}

CSPlayer@ get_closest_player(array<CSPlayer@>& players, Vector3 pLocalABS,CSPlayer@ pPlayer){
    CSPlayer@ closest;
    float max_distance = 100000;
    for(uint32 i = 0; i < players.length(); i++){
        if (players[i].entindex() != pPlayer.entindex() && players[i].is_alive()){
        float distance = (players[i].origin-pLocalABS).length();
        if(distance <  max_distance){
            max_distance = distance;  
            @closest = players[i];
            }
        }
    }
    return closest; 
}

//menu
KeySelector@ blockbot_key = null;
Slider@ blockbot_retreat_speed = null;
Checkbox@ blockbox_retreat = null;

int blockbot_previous_target = 0;
bool blockbot_crouch_block = false;

void blockbot_on_frame_main()
{
    if (blockbot_key is null || 
        !blockbot_key.is_down())
        return;

    CSPlayer@ blockbot_local_player = get_local_player();
    if (blockbot_local_player is null || !blockbot_local_player.is_alive())
		return;

    array<CSPlayer@> blockbot_players = get_all_players(true);

    CSPlayer@ blockbot_target = get_closest_player(blockbot_players, blockbot_local_player.eye_pos(), blockbot_local_player);

    if (blockbot_target is null || !blockbot_target.is_alive())
        return; 

    Vector3 pelvis_pos; 

    if (!blockbot_target.hitbox_position(3, pelvis_pos, 0))
        return; 

    Vector2 Pos = world_to_screen(pelvis_pos);
    //todo pos.valid
    Vector3 head_pos;

    if (!blockbot_target.hitbox_position(0, head_pos, 0))
        return; 

    Color clr = Color(255, 255, 255, 0);

    if (head_pos.z < blockbot_local_player.origin.z &&
        blockbot_target.origin.distance(blockbot_local_player.origin) < 100.0f)
    {
        blockbot_crouch_block = true;
        clr = Color(255, 255, 0, 255);
    }
    else {
        blockbot_crouch_block = false;
        clr = Color(255, 0, 0, 255);
    }
    Vector2 IconSize = text_size("BlockbotIcon", "X", 1.f);
    draw_text(Pos - IconSize, Vector2(), "BlockbotIcon", "X", clr, 0);

    Vector3 delta = blockbot_local_player.origin - blockbot_target.origin;
    string Distance = round(delta.length(), 1); 
    Color clr_dist = Color(64, 255, 64, 255);
    Vector2 DistanceSize = text_size("BlockbotText", Distance, 1.f);
    
/*     draw_text(Pos - DistanceSize, Vector2(), "BlockbotText", Distance, clr_dist, 0);
 */
    //velocity
    Vector3 TargetSpeed; 
    blockbot_target.read_prop("DT_CSPlayer", "m_vecVelocity[0]", TargetSpeed);
    clr = Color(64, 64, 255, 255);

    if (TargetSpeed.length() > blockbot_retreat_speed.value() && blockbox_retreat.value() == true)
        clr = Color(255, 255, 64, 255);

    string SpeedStr = round(TargetSpeed.length(), 1);
    Vector2 SpeedSize = text_size("BlockbotText", SpeedStr, 1.f);
    draw_text(Pos - SpeedSize, Vector2(), "BlockbotText" , SpeedStr, clr, 0);
    
    blockbot_previous_target = blockbot_target.entindex(); 

    /*for (auto idx = 0; idx < blockbot_players.length(); ++idx)
    {
        auto@ player = blockbot_players[idx]; 

        if (player is null)
            continue; 

        if (!player.is_alive())
            continue; 

        
    }*/
}

bool on_create_move(UserCmd& cmd, bool &out send_packet){
    if (blockbot_key is null || 
        !blockbot_key.is_down())
        return true; 

    CSPlayer@ local_player = get_local_player();
    auto@ player = get_player(blockbot_previous_target);

    if (player is null || !player.is_alive())
        return true;

        const auto LocalAngles = cmd.viewangles;
        const auto VecForward = player.origin - local_player.origin;
        const auto AimAngles = VecForward.vector_angle();
        Vector3 TargetSpeed;
        player.read_prop("DT_CSPlayer", "m_vecVelocity[0]", TargetSpeed);

        if(blockbot_crouch_block == true){
            cmd.forwardmove = cap( ((sin(rad(LocalAngles.y) ) *  VecForward.y) + (cos(rad(LocalAngles.y) ) * VecForward.x)) * 450, -450, 450);
            cmd.sidemove = cap( ((cos(rad(LocalAngles.y) ) * -VecForward.y) + (sin(rad(LocalAngles.y) ) * VecForward.x)) * 450, -450, 450);
        }
        else {
            float DiffYaw = AimAngles.y - LocalAngles.y;

            if (DiffYaw > 180.f)
                DiffYaw = DiffYaw -360.f;
            if (DiffYaw < -180.f)
                DiffYaw = DiffYaw + 360.f;  

            if(TargetSpeed.length() > blockbot_retreat_speed.value() && blockbox_retreat.value() == true)       
                cmd.forwardmove = -abs(TargetSpeed.length());

            if (DiffYaw > 0.25f)
                cmd.sidemove = -450.f;
            if (DiffYaw < -0.25f) 
                cmd.sidemove = 450.f;    
        }
        

        
    return true; 
}


bool initialize() {

	@blockbot_key = add_keyselector("Misc", "General", "Scripts - Blockbot", "Blockbot Key", 0);
    @blockbox_retreat = add_checkbox("Misc", "General", "Scripts - Blockbot", "Retreat on Bhop");
    @blockbot_retreat_speed = add_slider("Misc", "General", "Scripts - Blockbot", "Retreat Speed", 285.f, 300.f);

    add_font("BlockbotIcon", "C:\\Windows\\Fonts\\verdana.ttf", 64.0f);
    add_font("BlockbotText", "C:\\Windows\\Fonts\\verdana.ttf", 24.0f);

    
    if (!register_createmove_callback(on_create_move, "craxto is gay2"))
        return false; 

    if (!register_draw_callback(blockbot_on_frame_main, "craxto big gey hihihihi2"))
        return false; 

	return true;
}

bool shutdown() {
	remove_createmove_callback("craxto is gay2");

    remove_draw_callback("craxto big gey hihihihi2");

	return true; 
}