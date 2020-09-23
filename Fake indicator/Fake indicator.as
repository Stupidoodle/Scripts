Color faker;
Color c_lby;
Color red_green;
float lby;
float sim_time;
float delta;
float percent;
convar::ConVar@ cmd_ticks = null; 
Slider@ fakelag = find_slider("AntiAim", "AntiAims", "Fake Lag", "Fake Lag");
int tick;

bool fake_create_move(UserCmd &inout cmd, bool&out sendpacket){
    CSPlayer@ local_player = get_local_player();
    float fake = local_player.animstate(true).m_flGoalFeetYaw;
    float real = local_player.animstate(false).m_flGoalFeetYaw;
    float diff = real - fake;
    diff = abs(floor(diff));
    float green = diff * 2.125;
    float red = diff * 255;
    faker = Color(red, green, 0, 255);
    local_player.read_prop("DT_CSPlayer", "m_flLowerBodyYawTarget", lby);
    local_player.read_prop("DT_CSPlayer", "m_flSimulationTime", sim_time);
    delta = g_GlobalVars.curtime - sim_time;
    int choke = 0.5f + delta / g_GlobalVars.interval_per_tick;
    percent = choke;
    float lby_delta = abs(floor(abs(floor(lby)) - abs(floor(real))));
    string str_delta = lby_delta;
    if(lby_delta >= 36.f){
        c_lby = Color(25, 255, 0, 255);
    }
    else
        c_lby = Color(255, 25, 0, 255);

    if(diff <= 0){
        faker.r = 255;
    }

    if(sendpacket)
        red_green = Color(255, 25, 0, 255);
    else
        red_green = Color(25, 255, 0, 255);

    return true;
}
void fake_draw(){
    Vector2 screen = screen_size();
    CSPlayer@ local_player = get_local_player();
    draw_text(Vector2((screen.x - screen.x) + 5, screen.y - 75), Vector2(), "Verdana", "FAKE", faker, 5, 1.f);
    draw_text(Vector2((screen.x - screen.x) + 5, screen.y - 105), Vector2(), "Verdana", "FAKELAG", red_green, 5, 1.f);
    Vector3 origin = local_player.origin;
    Vector2 w2s1 = world_to_screen(origin);
    string test = percent;
    log_info(test);
    Vector2 to(w2s1.x + percent*5, w2s1.y + 5);
    draw_filled_rect(w2s1, to, Color(255, 255, 255, 255));
    draw_rect(w2s1, Vector2(w2s1.x + fakelag.value()*5, w2s1.y +6), Color(25, 25, 25, 255));
    //draw_text(Vector2((screen.x - screen.x) + 5, screen.y - 105), Vector2(), "Verdana", "LBY", c_lby, 5, 1.f);
}

bool shutdown(){
    remove_createmove_callback("fake_create_move");
    remove_draw_callback("fake_on_draw");
    return true;
}

bool initialize(){
    @cmd_ticks = convar::find_var("sv_maxusrcmdprocessticks"); 

    if(cmd_ticks is null)
        return false;

    tick = cmd_ticks.get_int();

    register_draw_callback(fake_draw, "fake_on_draw");
    add_font("Verdana", "C:\\Windows\\Fonts\\verdanab.ttf", 30);
    register_createmove_callback(fake_create_move, "fake_create_move");
    return true;
}

