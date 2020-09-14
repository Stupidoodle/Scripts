Checkbox@ enable = null;
Slider@ timer = null;

bool defusing = false;
bool defused;
float blow_time;
Vector3 bomb_place;
string some_shit;

int wait_ticks = 0;

void on_draw(){
}

void forentity(Entity@ entiy){
	entiy.read_prop("DT_PlantedC4", "m_bBombDefused", defused);
	entiy.read_prop("DT_PlantedC4", "m_flC4Blow", blow_time);
	entiy.read_prop("DT_PlantedC4", "m_vecOrigin", bomb_place);
}
	
bool on_create_move(UserCmd& cmd, bool &out send_packet){
	int defuse_time = 0;
	
	const auto@ local_player = get_local_player();
	
	if(local_player is null)
		return false;
		
	if(!local_player.is_alive())
		return false;
					
	bool defuse;
	
	local_player.read_prop("DT_CSPlayer", "m_bHasDefuser", defuse);
		
	if(defuse){
		defuse_time = 5;
	}
	else{
		defuse_time = 10;
	}
	
	if(!enable.value())
		return false;
			
	for_each_entity(forentity, 128);
	 
	
	if(defused)
		return false;
				
	if(bomb_place.distance(local_player.origin) > 75)
		return false; 
				
	if(abs(g_GlobalVars.curtime - blow_time) - defuse_time < 0 && !defusing)
		return false;
			
	if(abs(g_GlobalVars.curtime - blow_time) - defuse_time <= timer.value()){
		defusing = true;
		cmd.buttons = 32;
	}
	return true;
}

bool initialize() { 
	@enable = add_checkbox("Misc", "General", "Scripts - Last Second Defuser", "Last second Defuse");
	@timer = add_slider("Misc", "General", "Scripts - Last Second Defuser", "Window", 0.05f, 3.f);
	register_createmove_callback(on_create_move, "callback111");
	register_draw_callback(on_draw, "drawer111");
	
	return true;
}

bool shutdown(){
	remove_createmove_callback("callback111");
	remove_draw_callback("drawer111");
	return true;
}












