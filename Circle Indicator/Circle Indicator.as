Slider@ radius_circle;
Slider@ length_arc;
Slider@ thickness_arc;
Slider@ precision_arc;
Slider@ x_offset;
Slider@ y_offset;

Checkbox@ middle;

float real_yaw;
float view_yaw;
float lower_body_yaw;

Vector3 view_angles;

Vector2 screensize;

Color color_circle = Color(120, 120, 120, 192);
Color color_real = Color(255, 0, 196, 255);
Color color_fake = Color(170, 128, 255, 255);
Color color_lower_body_yaw = Color(255, 255, 255, 255);

void update_settings(){
    if(thickness_arc.value() > radius_circle.value())
        thickness_arc.value(int(radius_circle.value()));
}

void circle_draw(Vector2 screensize, int radius, int thickness, Color color){
    int inner = radius - int(thickness_arc.value());

    for(; radius > inner; --radius){
        draw_circle(screensize, radius, color, 256);
    }

}

void arc_draw(Vector2 screensize, int radius, float start_angle, int percent, int thickness, Color color){
    float precision = (2 * 3.14159265359f) / precision_arc.value();
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

float adjust_angle(float angle){
    if(angle < 0){
        angle = (90 + angle * (-1));
    }
    else if(angle > 0){
        angle = (90 - angle);
    }
    return angle;
}

bool circle_on_create_move(UserCmd& cmd, bool &out send_packet){
    CSPlayer@ player = get_local_player();

    if (player is null)
        return true;

    if (!player.is_alive())
        return true;

    update_settings();

    player.read_prop("DT_CSPlayer", "m_flLowerBodyYawTarget", lower_body_yaw);
 
    player.read_prop("DT_CSPlayer", "m_angEyeAngles", view_angles);
    
    view_yaw = view_angles.y - 180;

	return true;
}

void circle_drawer(){
    CSPlayer@ player = get_local_player();

    if (player is null)
        return;

    if (!player.is_alive())
        return;
        
    float fake_yaw = player.animstate(true).m_flGoalFeetYaw;
    real_yaw = player.animstate(false).m_flGoalFeetYaw;
    float fake = adjust_angle(real_yaw - view_yaw);
    float real = adjust_angle(fake_yaw - view_yaw);
    float lby  = adjust_angle(lower_body_yaw - view_yaw);

    screensize = screen_size();

    if(middle.value() == true){
        screensize.x = screensize.x * 0.5;
        screensize.y = screensize.y * 0.5;
    }
    else{
        screensize.x = x_offset.value();
        screensize.y = y_offset.value();
    }
    circle_draw(screensize, int(radius_circle.value()), int(thickness_arc.value()), color_circle);
    arc_draw(screensize, int(radius_circle.value()), fake - (int(length_arc.value()) * 0.5f), int(length_arc.value()), int(thickness_arc.value()), color_fake);
    arc_draw(screensize, int(radius_circle.value()), real - (int(length_arc.value()) * 0.5f), int(length_arc.value()), int(thickness_arc.value()), color_real);
    arc_draw(screensize, int(radius_circle.value()), lby - (int(length_arc.value()) * 0.5f), int(length_arc.value()), int(thickness_arc.value()), color_lower_body_yaw);
}

bool shutdown() { // IMPORTANT! Script cant be unloaded if this function is missing!
	remove_createmove_callback("read_prop_example"); // soon obsolete
    remove_draw_callback("blackiimov");
    
    return true;
}

bool initialize() {
    @radius_circle = add_slider("Misc", "Misc", "Scripts - Circle Indicator", "Circle Radius", 10.f, 50.f);
    @length_arc = add_slider("Misc", "Misc", "Scripts - Circle Indicator", "Arc Length", 0.f, 90.f);
    @thickness_arc = add_slider("Misc", "Misc", "Scripts - Circle Indicator", "Arc Thickness", 0.f, 20.f);
    @precision_arc = add_slider("Misc", "Misc", "Scripts - Circle Indicator", "Arc Precision", 20.f, 1000.f);
    @x_offset = add_slider("Misc", "Misc", "Scripts - Circle Indicator", "X Offset", 0.f, 1920.f);
    @y_offset = add_slider("Misc", "Misc", "Scripts - Circle Indicator", "Y Offset", 0.f, 1080.f);
    @middle = add_checkbox("Misc", "Misc", "Scripts - Circle Indicator", "Center Circle");

    radius_circle.format("%0.0f");
    length_arc.format("%0.0f");
    thickness_arc.format("%0.0f");
    precision_arc.format("%0.0f");
    x_offset.format("%0.0f");
    y_offset.format("%0.0f");

    radius_circle.value(30);
    length_arc.value(45);
    thickness_arc.value(5);
    precision_arc.value(280);
    x_offset.value(screensize.x * 0.5f);
    y_offset.value(screensize.y * 0.5f);

	if (!register_createmove_callback(circle_on_create_move, "read_prop_example"))
		return false; // not loaded succesfully

    if (!register_draw_callback(circle_drawer, "blackiimov"))
        return false;

	return true; // script was initialized as needed
}


















