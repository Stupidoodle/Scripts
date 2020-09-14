Checkbox@ master_switch;

array<string> hitbox = {"Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg"};

void chat_log(GameEvent@ event){
    int ent_index = userid_to_entidx(event.get_uint("userid"));
    int me_index = userid_to_entidx(event.get_uint("attacker"));
    CSPlayer@ meme = get_player(me_index);
    CSPlayer@ atackking = get_player(ent_index);
    CSPlayer@ local_player = get_local_player();
    string me = local_player.get_name();
    string att = meme.get_name();

    if (att == me){
    string attacker = "\x03" + atackking.get_name() + "\x01";

    int part = event.get_uint("hitgroup") - 1;
    int dmg = event.get_uint("dmg_health");
    int remains = event.get_uint("health");

    log_chat("[\x01p\x0CUnk\x01nown] \x01Hit: " + attacker + " in: " + hitbox[part] + " for: \x04" + dmg + " \x01(\x02" + remains + " \x01HP remaining)");
    }
}

bool shutdown(){
    remove_event_callback("craxto big gey hihihhiiihihihihihi1");
    
    return true;
}

bool initialize(){

    register_event_callback(chat_log, "craxto big gey hihihhiiihihihihihi1", "player_hurt");

    return true;
}





