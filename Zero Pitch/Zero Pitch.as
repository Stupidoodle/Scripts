Dropdown@ pitch = find_dropdown("Misc", "AntiAims", "Anti Aims", "Pitch AntiAim");
Checkbox@ aa = find_checkbox("Misc", "AntiAims", "Anti Aims", "Enabled Antiaims");

bool zero_move(UserCmd &inout cmd, bool&out sendpacket){
    CSPlayer@ local_player = get_local_player();
    Vector3 wanted_yaw;
    wanted_yaw.y = cmd.viewangles.y;
    wanted_yaw.z = cmd.viewangles.z;

    if(aa.value()){
        if (local_player is null || !local_player.is_alive()){
            return false;
        }
        else{
            if(local_player.animstate(false).m_bInHitGroundAnimation == true){
                if((cmd.buttons & IN_ATTACK) == IN_ATTACK || (cmd.buttons & IN_USE) == IN_USE){
                    cmd.set_angle(cmd.viewangles, true);
                }
                else{
                    wanted_yaw.x = 0.f;
                    cmd.set_angle(wanted_yaw, true);
                }
            }
            else if(local_player.animstate(false).m_bInHitGroundAnimation == false){
                pitch.value(1);
            }
        }  
    }    
    return true;
}
    

bool initialize(){
    return register_createmove_callback(zero_move, "zero_move");
}