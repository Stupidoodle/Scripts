Slider@ fakelag = find_slider("AntiAim", "AntiAims", "Fake Lag", "Fake Lag");
Slider@ fakelag_run = find_slider("AntiAim", "AntiAims", "Fake Lag", "Fake Lag Running");
Slider@ fakelag_air = find_slider("AntiAim", "AntiAims", "Fake Lag", "Fake Lag In Air");
Slider@ fakelag_fd = find_slider("AntiAim", "AntiAims", "Fake Lag", "Fake Lag while FDucking");
Slider@ fl = null;
Slider@ fl_run = null;
Slider@ fl_air = null;
Dropdown@ fl_mode = null;

array<string> yes = {"Fluctuate", "Random"};

int fl_fluc_tick;

int change_for_fluctate = 4;

float speed;

bool weird;

void create_move(){
    CSPlayer@ local_player = get_local_player();
	if (local_player is null)
		return; 

	if (!local_player.is_alive())
		return; 
		
	auto test_velo = local_player.velocity;
	speed = floor(test_velo.length2d());
    switch(fl_mode.value()){
        case 0:
            if(speed <= 0 && local_player.animstate(false).m_bOnGround){
                if(fl_fluc_tick >= fl.value()){
                    weird = false;
                    fl_fluc_tick = 0;        
                }  
                else{
                    weird = true;
                    fl_fluc_tick = fl_fluc_tick + 1;
                } 
                if(!weird){
                    fakelag.value(fl.value());
                }
                else{
                    fakelag.value(fl_fluc_tick);
                }
            }
            else if(local_player.animstate(false).m_bOnGround){
               if(fl_fluc_tick >= fl_run.value()){
                    weird = false;
                    fl_fluc_tick = 0;        
                }  
                else{
                    weird = true;
                    fl_fluc_tick = fl_fluc_tick + 1;
                } 
                if(!weird){
                    fakelag_run.value(fl_run.value());
                }
                else{
                    fakelag_run.value(fl_fluc_tick);
                } 
            }

            if(!local_player.animstate(false).m_bOnGround){
                if(fl_fluc_tick >= fl_air.value()){
                    weird = false;
                    fl_fluc_tick = 0;        
                }  
                else{
                    weird = true;
                    fl_fluc_tick = fl_fluc_tick + 1;
                } 
                if(!weird){
                    fakelag_air.value(fl_air.value());
                }
                else{
                    fakelag_air.value(fl_fluc_tick);
                }
            }
        break;
        case 1:
            if(speed <= 0 && local_player.animstate(false).m_bOnGround){
                fakelag.value(random_int(0, fl.value()));
            }
            else if(local_player.animstate(false).m_bOnGround){
                fakelag_run.value(random_int(0, fl_run.value()));
            }

            if(!local_player.animstate(false).m_bOnGround){
                fakelag_air.value(random_int(0, fl_air.value()));
            }
        break;
    }
}

bool initialize(){
    @fl_mode = add_dropdown("AntiAim", "AntiAims", "Scripts - Fakelag Modes", "Fakelag Mode");
    fl_mode.entry_list(yes);
    @fl = add_slider("AntiAim", "AntiAims", "Scripts - Fakelag Modes", "Fluctuate Standing", 0.f, 14.f);
    fl.format("%0.0f Ticks");
    @fl_run = add_slider("AntiAim", "AntiAims", "Scripts - Fakelag Modes", "Fluctuate Running", 0.f, 14.f);
    fl_run.format("%0.0f Ticks");
    @fl_air = add_slider("AntiAim", "AntiAims", "Scripts - Fakelag Modes", "Fluctuate Air", 0.f, 14.f);
    fl_air.format("%0.0f Ticks");
    
    if(fl_mode is null || fl is null || fl_run is null || fl_air is null){
        return false;
    }

    return register_draw_callback(create_move, "fl_create_move");
}