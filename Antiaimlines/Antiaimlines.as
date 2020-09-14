float lastchoked;
bool choking;
float lastchoke;
float lby;
Vector3 fake;
Vector3 localAngle;
Slider@ line_length;
Slider@ text_offset_x;
Slider@ text_offset_y;




float rad(float x){
    return x * (3.14159265359f / 180.f);
}

bool aa_on_create_move(UserCmd& cmd, bool &out send_packet){


    const auto@ local_player = get_local_player(); 

    if (local_player is null)
        return true; // return, since we dont have a valid entity

    if (!local_player.is_alive())
        return true; // return, since the localplayer isnt alive

    local_player.read_prop("DT_CSPlayer", "m_flLowerBodyYawTarget", lby);

    local_player.read_prop("DT_CSPlayer", "m_angEyeAngles", fake);

    if(!send_packet){
        lastchoked = local_player.animstate(false).m_flGoalFeetYaw;
        choking = true;
        lastchoke = g_GlobalVars.curtime;
    }
    else{
        localAngle = cmd.viewangles;
    }

    if(lastchoke <= g_GlobalVars.curtime - 1)
        choking = false;

    return true;
}

Vector3 AngleVectors(int x, float y, int z){
    Vector3 forward;
    float sy = sin(rad(y));
    float cy = cos(rad(y));
    float sp = sin(rad(x));
    float cp = cos(rad(x));
    forward.x = cp*cy;
    forward.y = cp*sy;
    forward.z = -sp;
    return forward;
}

Vector3 doShit(Vector3 t1, Vector3 t2, float m){
    Vector3 t3;
    t3.x = t1.x + (t2.x * m);
    t3.y = t1.y + (t2.y * m);
    t3.z = t1.z + (t2.z * m);
    return t3;
}

void aa_draw(float value, uint8 r, uint8 g, uint8 b, uint8 a, string text){
    Vector3 forward;
    const auto@ local_player = get_local_player();
    Vector3 origin = local_player.origin;
    forward = AngleVectors(0, value, 0);
    Vector3 end3D = doShit(origin, forward, line_length.value());
    Vector2 w2s1 = world_to_screen(origin);
    Vector2 w2s2 = world_to_screen(end3D);
    Color linecolor = Color(r, g, b, a);

    //if(w2s1 && w2s2) // bool operator
        draw_line(w2s1, w2s2, linecolor, 1.0f);
        Vector2 textsize = text_size("Linefont", text, 1.f);
        w2s2.x = w2s2.x + text_offset_x.value();
        w2s2.y = w2s2.y - text_offset_y.value();
        draw_text(w2s2 - (textsize/2), Vector2(), "Linefont", text, linecolor, 0, 1.0f); // removed
    //
}

void aamain(){
    const auto@ local_player = get_local_player(); 

    if (local_player is null)
        return; // return, since we dont have a valid entity

    if (!local_player.is_alive())
        return; // return, since the localplayer isnt alive
        
    float desync = local_player.animstate(true).m_flGoalFeetYaw;
    float real = local_player.animstate(false).m_flGoalFeetYaw;

    if(choking == true) // bool operators
        aa_draw(lastchoked, 25, 255, 25, 255, "Last Choked");

    //if(fake)
        aa_draw(fake.y, 255, 25, 25, 255, "Viewangle");
    
    //if(localAngle)
        aa_draw(real, 25, 25, 255, 255, "Fake");
    
    //if(lby)
        aa_draw(lby, 255, 255, 255, 255, "LBY");

        aa_draw(desync, 0, 255, 255, 255, "Real");
    
}

bool initialize() {

    @line_length = add_slider("Misc", "General", "Scripts - Anti-Aim Lines", "Anti-Aim Line length", 20.f, 100.f);
    @text_offset_x = add_slider("Misc", "General", "Scripts - Anti-Aim Lines", "Text Offset X", -30.f, 20.f);
    @text_offset_y = add_slider("Misc", "General", "Scripts - Anti-Aim Lines", "Text Offset Y", 0.f, 20.f);

    line_length.value(30.f);
    text_offset_x.value(-30.f);
    text_offset_y.value(15.f);
    
    add_font("Linefont", "C:\\Windows\\Fonts\\verdana.ttf", 14.0f);
    add_font("Linefont v2", "C:\\Windows\\Fonts\\tahoma.ttf", 14.0f);
    
/*     register_draw_callback(drawer, "dasmax alphamale");
 */
    register_createmove_callback(aa_on_create_move, "squidoodle retard");

    register_draw_callback(aamain, "dasmax betamale");

	return true;
}

bool shutdown() {
    remove_createmove_callback("squidoodle retard");
    remove_draw_callback("dasmax betamale");

    return true; 
}


