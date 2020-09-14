KeySelector@ fake_key;
Slider@ speeding;
Checkbox@ circle;

float jetzt;
float letzter = 361.f;
float zufall;
float delta;

bool einmal = true;
bool aktiv;
bool release;

float rad(float x){
    return x * (3.14159265359f / 180.f);
}

float setangle(float ziel, float wert, float geschwindigkeit){
    delta = ziel - wert;

    if(geschwindigkeit < 0)
        geschwindigkeit = -geschwindigkeit;

    if(delta <= -180)
        delta += 360;
    else if(delta >= 180)
        delta -= -360;

    if(delta > geschwindigkeit)
        wert += geschwindigkeit;
    else if(delta < -geschwindigkeit)
        wert -= geschwindigkeit;
    else
        wert = ziel;

    return wert;
}

void draw(){
    if(fake_key.is_down()){
        if(!aktiv)
            aktiv = true;
        else
            aktiv = false;
    }

    Vector2 screensize = screen_size(); // i knew this without looking in the docs 😎

    if(circle.value() == true){
        Vector2 screenlol;
        screenlol.x = screensize.x / 2;
        screenlol.y = screensize.y / 3;
        Vector2 endl;
        endl.x = screensize.x / 2 + sin(rad(jetzt - letzter + 180)) * 15;
        endl.y = screensize.y / 3 + cos(rad(jetzt - letzter + 180)) * 15;
        draw_line( screenlol, endl, Color(255, 255, 255, 255));
        draw_circle(screenlol, 16.f, Color(255, 255, 255, 255), 256);
    }
}

int i = 0;

bool create_move(UserCmd& cmd, bool &out send_packet){
    if(einmal){
        zufall = random_int(160, 180);
        einmal = false;
    }
/*     
    if(!fake_key.is_down()){
        einmal = true;
    }
 */
    Vector3 viewangle = cmd.viewangles;
    jetzt = viewangle.y;

    if(letzter == 361.f)
        letzter = viewangle.y;
    
    if(fake_key.is_down()){
        letzter = setangle(viewangle.y + zufall, letzter, speeding.value());
    }
    else if(release){
        letzter = setangle(cmd.viewangles.y, letzter, speeding.value());
    }
        

    Vector3 gay_angle;
    gay_angle.x = viewangle.x;
    gay_angle.y = letzter;
    gay_angle.z = viewangle.z;

    cmd.set_angle(gay_angle, true);
    
    return true;
}

void key_released(uint key, uint action){
    if(fake_key.value() == key){
        if(action == 2){
            einmal = true;log_info("dein penis klein");
            release = true;
        }
        else{
            release = false;
        }
    }
}

bool shutdown(){
    remove_createmove_callback("Inmybutthole");
    remove_draw_callback("noggers");

    return true;
}


bool initialize(){
    @fake_key = add_keyselector("Misc", "General", "Scripts - Fake Backwards", "Fake Backwards Key", 0);
    @speeding = add_slider("Misc", "General", "Scripts - Fake Backwards", "Fake Backwards Speed", 1.f, 20.f);
    @circle = add_checkbox("Misc", "General", "Scripts - Fake Backwards", "Circle Indicator");

    register_createmove_callback(create_move, "Inmybutthole");

    register_draw_callback(draw, "noggers");

    input::register_key_callback(key_released);

    return true;
}

















