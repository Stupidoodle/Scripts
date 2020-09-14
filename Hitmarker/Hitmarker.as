//
Checkbox@ rainbox_check = null;
Slider@ rainbow_speed = null;
int speed = 3;
Color yellow = Color(255, 255, 0, 255);
Color rainbow;
Vector2 pos;
Vector2 screen;
Vector3 hitbox_pos;
float lasttime;
string dmg;
bool set_pos;
bool timer;
Slider@ fade_out = null;
int i;
int part;
string i_ = i;
int o = 0;
array<Vector2> position;
array<string> damage;
//1 = head
//2 = chest
//3 = pelvis
//4 = left arm
//5 = righ arm
//6 = left knee
//7 = right knee


string tostring(int conversion){
    string output = conversion;
    return output;
}

array<int> lmaoboxes = {
    69,
    0,
    6,
    2,
    14,
    13,
    11,
    12,
};




void hit_chat_log(GameEvent@ event){
    int ent_index = userid_to_entidx(event.get_uint("userid"));
    int me_index = userid_to_entidx(event.get_uint("attacker"));
    CSPlayer@ meme = get_player(me_index);
    CSPlayer@ atackking = get_player(ent_index);
    CSPlayer@ local_player = get_local_player();
    int local_player_idx = local_player.entindex();
    string me = local_player.get_name();
    string att = meme.get_name();
    yellow.a = 255;
    rainbow.a = 255;

    if (me_index == local_player_idx){    
        part = event.get_uint("hitgroup");  

        if(part == 1){
            yellow = Color(75, 255, 0, yellow.a);
        }
        else{
            yellow = Color(255, 25, 25, yellow.a);
        }

        string dmg = event.get_uint("dmg_health");
        atackking.hitbox_position(lmaoboxes[part] , hitbox_pos, 0);
        damage.insertLast(dmg);
        position.insertLast(world_to_screen(hitbox_pos));
        set_pos = true;
    }
}

void hit_draw(){
    speed = rainbow_speed.value();
    rainbow = Color(floor(sin(g_GlobalVars.realtime * speed) * 127 + 128), floor(sin(g_GlobalVars.realtime * speed + 2) * 127 + 128), floor(sin(g_GlobalVars.realtime * speed + 4) * 127 + 128), rainbow.a);

    if(!rainbox_check.value()){
        if(!set_pos){
            if(yellow.a >= 0 && yellow.a != 0){
                yellow.a--;
            }
            if(yellow.a == 1){
                yellow.a = 0;
            }
        }
    }
    if(rainbox_check.value()){
        if(!set_pos){
            if(rainbow.a >= 0 && rainbow.a != 0){
                rainbow.a--;
            }
            if(rainbow.a == 1){
                rainbow.a = 0;
            }
        }
    }

    for(uint32 x = 0; x < damage.length(); x++){
        if(g_GlobalVars.curtime >= lasttime){
            lasttime = g_GlobalVars.curtime - (fade_out.value() / 100);
        }

        if(set_pos){
            if(g_GlobalVars.curtime >= lasttime){
                set_pos = false;
            }
        }
        if(!rainbox_check.value())
            draw_text(position[x], Vector2(), "Verdana", "-" + damage[x], yellow, 0, 0.7f);
        else
            draw_text(position[x], Vector2(), "Verdana", "-" + damage[x], rainbow, 0, 0.7f);
        if(yellow.a <= 50 || rainbow.a <= 50){
            position[x] = Vector2(-500, -500);
            damage[x] = "";
        }
    }
}

bool shutdown(){
    remove_event_callback("craxto big gey hihiihihihiihihihihihi");
    remove_draw_callback("on_draw");
    
    return true;
}

bool initialize(){
    register_draw_callback(hit_draw, "hit_on_draw");
    register_event_callback(hit_chat_log, "craxto big gey hihiihihihiihihihihihi", "player_hurt");
    add_font("Verdana", "C:\\Windows\\Fonts\\verdanab.ttf", 30);
    @fade_out = add_slider("Misc", "General", "Hitmarker", "Time until Fade-out", 0, 5);
    @rainbox_check = add_checkbox("Misc", "General", "Hitmarker", "Rainbow");
    @rainbow_speed = add_slider("Misc", "General", "Hitmarker", "Rainbox Speed", 0, 10);

    return true;
}





