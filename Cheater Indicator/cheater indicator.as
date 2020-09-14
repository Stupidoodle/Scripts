
Checkbox@ check_cheater = null;

array<esp::ESPText> cheater(CSPlayer@ players){
    
    array<esp::ESPText> is_cheater;

    if(!check_cheater.value())
    return is_cheater;

    CSPlayer@ pPlayer = get_local_player();
    
    if(players !is null or pPlayer !is null){
        
        uint32 index = players.entindex();
        Vector3 m_angEyeAngles;
        float m_flLowerBodyYawTarget;
        players.read_prop("DT_CSPlayer", "m_angEyeAngles", m_angEyeAngles);
        players.read_prop("DT_CSPlayer", "m_flLowerBodyYawTarget", m_flLowerBodyYawTarget);
		m_angEyeAngles = m_angEyeAngles.normalize_angles();

        if( m_angEyeAngles.y - m_flLowerBodyYawTarget >= 36.f){

            is_cheater.insertAt(0, esp::ESPText(2, "LBY Breaking"));
        }

        if(floor(m_angEyeAngles.x) == -89 || m_angEyeAngles.x == -88.99f){

            is_cheater.insertAt(0, esp::ESPText(2, "Pitch Up"));
        }

        if(ceil(m_angEyeAngles.x) == 89.f || m_angEyeAngles.x == 88.99f){          

            is_cheater.insertAt(0, esp::ESPText(2, "Pitch Down"));
        }
    }

    return is_cheater;
}

bool shutdown() {

	return true; 
}

bool initialize() {

    @check_cheater = add_checkbox("Misc", "Misc", "Scripts - Cheater ESP", "Cheater ESP");

    if(check_cheater is null)
    return false;

    esp::add_text_callback(cheater);
    return true;
}











