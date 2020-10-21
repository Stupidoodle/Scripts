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

float rad(float x){
    return x * (3.14159265359f / 180.f);
}

Vector3 doShit(Vector3 t1, Vector3 t2, float m){
    Vector3 t3;
    t3.x = t1.x + (t2.x * m);
    t3.y = t1.y + (t2.y * m);
    t3.z = t1.z + (t2.z * m);
    return t3;
}

void draw_angle(float value, Color linecolor, string text){ // draw an angle below the player
    Vector3 forward;
    const auto@ local_player = get_local_player();
    Vector3 origin = local_player.origin;
    forward = AngleVectors(0, value, 0);
    Vector3 end3D = doShit(origin, forward, 30); // insert le length
    Vector2 w2s1 = world_to_screen(origin);
    Vector2 w2s2 = world_to_screen(end3D);

    draw_line(w2s1, w2s2, linecolor, 1.0f);
    Vector2 textsize = text_size("", text, 1.f);// insert le custom font here
    w2s2.x = w2s2.x; //offset
    w2s2.y = w2s2.y; //offset
    draw_text(w2s2 - (textsize/2), Vector2(), "", text, linecolor, 0, 1.0f); // removed
}

int thicknesss = 5;
int radiuss = 10;
int precisionn = 250;

void update_settings(){
    if(thicknesss > radiuss)
        thicknesss = radiuss;
}

void circle_draw(Vector2 screensize, int radius, int thickness, Color color){ //can be circle filled half filled what u want
    int inner = radius - int(thicknesss);

    for(; radius > inner; --radius){
        draw_circle(screensize, radius, color, 256);
    }
}

void arc_draw(Vector2 screensize, int radius, float start_angle, int percent, int thickness, Color color){ //draw an arc that moves accordingly to the angle
    float precision = (2 * 3.14159265359f) / precisionn;
    float step = 3.14159265359f / 180;
    float inner = radius - thickness;
    float end_angle = (start_angle + percent) * step;
    float angle_start = (start_angle * 3.14159265359f) / 180;

    for(; radius > inner; --radius){
        for(float angle = angle_start; angle < end_angle; angle += precision){
            int cx = int(screensize.x + radius * cos(angle));
            int cy = int(screensize.y + radius * sin(angle));

            int cx2 = int(screensize.x + radius * cos(angle + precision));
            int cy2 = int(screensize.y + radius * sin(angle + precision));

            draw_line(Vector2(cx, cy), Vector2(cx2, cy2), color);
        }
    }
}

float adjust_angle(float angle){ // prepare an angle wiht this sexy fucntion
    if(angle < 0){
        angle = (90 + angle * (-1));
    }
    else if(angle > 0){
        angle = (90 - angle);
    }
    return angle;
}