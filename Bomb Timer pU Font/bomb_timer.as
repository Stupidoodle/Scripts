Checkbox@ timer_enable = null;
//Dropdown@ where = null;
//array<string> inserter = {"Top", "Left", "Bottom", "Right"};
float flblow;
float fldefuse;
float fltimer;
bool BombDefused;
int defuser;
Vector3 vec_origin;

void forentity(Entity@ entiy){
    if(entiy is null){
        log_info("retarde");
    }
    else{
        entiy.read_prop("DT_PlantedC4", "m_bBombDefused", BombDefused);
        entiy.read_prop("DT_PlantedC4", "m_flC4Blow", flblow);
        entiy.read_prop("DT_PlantedC4", "m_flDefuseCountDown", fldefuse);
        entiy.read_prop("DT_PlantedC4", "m_flTimerLength", fltimer);
        entiy.read_prop("DT_PlantedC4", "m_hBombDefuser", defuser);    
        entiy.read_prop("DT_PlantedC4", "m_vecOrigin", vec_origin);
    }	
}

void bombus(){
    if (timer_enable.value())
    {
		for_each_entity(forentity, 128);
        Vector2 screensize = screen_size();

        CSPlayer@ local_player = get_local_player();
        
        float ExplodeTimeRemaining = flblow - (local_player.read_uint("DT_CSPlayer", "m_nTickBase") * g_GlobalVars.interval_per_tick);//subtract current time to get time remaining

        //time bomb is expected to defuse. if defuse is cancelled and started again this will be changed to the new value
        float DefuseTimeRemaining = fldefuse - (local_player.read_uint("DT_CSPlayer", "m_nTickBase") * g_GlobalVars.interval_per_tick);//subtract current time to get time remaining

        string TimeToExplode = "Explode in : " + fmt_float("%.1f", ExplodeTimeRemaining);//Text we gonna display for explosion

        string TimeToDefuse = "Defuse in : " + fmt_float("%.1f", DefuseTimeRemaining);//Text we gonna display for defuse

        int width, height;//text width and height for rendering in correct place. your cheat may get text height as a rect with both width and height
        Vector2 size_time = text_size("", TimeToExplode);
        Vector2 size_c4 = text_size("", "C4");
        width = size_time.x;
        height = size_c4.y;//I'm drawing this below my name esp

        if (ExplodeTimeRemaining > 0 && !BombDefused)//m_bBombDefused (offset 1352) (type integer) (bits 1) (Unsigned)
        {	
            float fraction = ExplodeTimeRemaining / fltimer;
            int onscreenwidth;

            float red = 255 - (fraction * 255);
            float green = fraction * 255;

            Color fader = Color(red, green, 0, 255);
            Vector2 w2s = world_to_screen(vec_origin);
            /* draw_circle(w2s, 16, Color(25, 25, 25, 150), 250); */
            arc_draw(w2s, 15, -90.f, int(ExplodeTimeRemaining * 9), 3, fader);
            draw_text(w2s, Vector2(), "", TimeToExplode, fader, 5);
            onscreenwidth = fraction * screensize.x;
            draw_filled_rect(Vector2(0, 0), Vector2(onscreenwidth, 10), fader);
            draw_rect(Vector2(0, 0), Vector2(onscreenwidth, 10), Color(0, 0, 0, 100));
            draw_text(Vector2(onscreenwidth - width, 10), Vector2(), "", TimeToExplode, fader, 5);
            /* else if(where.value() == 1){
                onscreenwidth = fraction * screensize.y;
                draw_filled_rect(Vector2(0, screensize.y), Vector2(10, onscreenwidth), fader);
                draw_rect(Vector2(0, screensize.y), Vector2(10, onscreenwidth), Color(0, 0, 0, 100));
                draw_text(Vector2(onscreenwidth - width, 10), Vector2(), , TimeToExplode, fader, 5);
            } */
        } 
		Vector2 size_defuse = text_size("", TimeToDefuse);
		width = size_defuse.x;
			
		if(defuser != -1){
			float fraction2 = DefuseTimeRemaining / fltimer;
            int onscreenwidth = fraction2 * screensize.x;

            Color blue = Color(0,0,255, 255);
            /* arc_draw(Vector2(500, 500), 30, -90.f, int(ExplodeTimeRemaining * 9 - DefuseTimeRemaining), 5, blue); */
            draw_filled_rect(Vector2(0, 10), Vector2(onscreenwidth, 20), blue);
            draw_rect(Vector2(0, 10), Vector2(onscreenwidth, 20), Color(0, 0, 0, 100));
            draw_text(Vector2(onscreenwidth - width, 20), Vector2(), "", TimeToDefuse, blue, 5);
		}
    }
}

bool shutdown(){
    remove_draw_callback("bombar");

    return true;
}

bool initialize(){
	@timer_enable = add_checkbox("Misc", "General", "Scripts - Bomb Timer", "Timer");
    //@where = add_dropdown("Misc", "General", "Scripts", "Position");
    //where.entry_list(inserter);
    register_draw_callback(bombus, "bombar");
	timer_enable.value(true);
    //add_font(, "C:\\Windows\\Fonts\\verdana.ttf", 14.0f);
    return true;
}















