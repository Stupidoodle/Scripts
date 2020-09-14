Checkbox@ jumb_enable = null;
KeySelector@ jumb_key = null;
Dropdown@ bhop = null;
bool unduck = false;

bool DoJumpBug(UserCmd& cmd, bool &out send_packet){
    if (!jumb_enable.value() == true)
        return true;
    
    CSPlayer@ player = get_local_player();
    float max_radias = 3.1415926535897932384626 * 2;
    float step = max_radias / 128;
    float xThick = 23;
    bool on_ground = player.animstate(false).m_bOnGround; 

    if (jumb_enable.value() == true && jumb_key.is_down() && on_ground == false) { 
        bhop.value(0);

        Vector2 screenee = screen_size();

        if(unduck == true){

            cmd.buttons &= ~IN_DUCK; // duck
            cmd.buttons |= IN_JUMP; // jump
            unduck = false;

        }

        Vector3 pos = player.origin;
        string height = pos.z;
        log_info(height);

        for (float a = 0.f; a < max_radias; a += step) {

            Vector3 pt;
            pt.x = (xThick * cos(a)) + pos.x;
            pt.y = (xThick * sin(a)) + pos.y;
            pt.z = pos.z;

            Vector3 pt2 = pt;
            pt2.z -= 6;

            TraceInfo info; 
            trace_ray(pt, pt2, player, info, MASK_SHOT);


            if (info.fraction != 1.f && info.fraction != 0.f) {

                cmd.buttons |= IN_DUCK; // duck
                cmd.buttons &= ~IN_JUMP; // jump
                unduck = true;

            }

        }

        for (float a = 0.f; a < max_radias; a += step) {

            Vector3 pt;
            pt.x = ((xThick - 2.f) * cos(a)) + pos.x;
            pt.y = ((xThick - 2.f) * sin(a)) + pos.y;
            pt.z = pos.z;

            Vector3 pt2 = pt;
            pt2.z -= 6;

            TraceInfo info; 
            trace_ray(pt, pt2, player, info, MASK_SHOT);

            if (info.fraction != 1.f && info.fraction != 0.f) {

                cmd.buttons |= IN_DUCK; // duck
                cmd.buttons &= ~IN_JUMP; // jump
                unduck = true;

            }

        }
        
        for (float a = 0.f; a < max_radias; a += step) {
            Vector3 pt;
            pt.x = ((xThick - 20.f)* cos(a)) + pos.x;
            pt.y = ((xThick - 20.f) * sin(a)) + pos.y;
            pt.z = pos.z;

            Vector3 pt2 = pt;
            pt2.z -= 6;

            TraceInfo info; 
            trace_ray(pt, pt2, player, info, MASK_SHOT);

            if (info.fraction != 1.f && info.fraction != 0.f) {

                cmd.buttons |= IN_DUCK; // duck
                cmd.buttons &= ~IN_JUMP; // jump
                unduck = true;

            }
        }
    }
    else
        bhop.value(2);

    return true;	
}

bool initialize() {

    @bhop = find_dropdown("Misc", "General", "Scripts - Jumpbug", "BunnyHop Enabled");
    @jumb_enable = add_checkbox("Misc", "General", "Scripts - Jumpbug", "Enable Jumb Bug");
    @jumb_key = add_keyselector("Misc", "General", "Scripts - Jumpbug", "Jumpbug Key", 0);
    

    
    if (!register_createmove_callback(DoJumpBug, "craxto is gay111"))
        return false; 

	return true;
}