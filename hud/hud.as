int local_ammo;
int local_money;
int local_health;
int local_armor;
auto test_velo;
float speed;
float final_speed;
PlayerWeapon@ local_weapon;
Color white = Color(255, 255, 255, 255);
Color health;
Color blue = Color(60, 155, 255, 255);
array<string> weapons(525);
int test_weapon;
int cur_weapon;
//2 = dual
//36 = p250
//3 = fiveSeven
//1 = deagle
//61 = usp
//35 = nova
//25 = xmx
//27 = mag
//14 = m249
//28 = niggev
//34 = smg
//23 = mp5
//24 = ump
//19 = p90
//26 = pp
//10 = famas
//60 = m4a1s
//40 = scout
//8 = aug
//9 = awp
//38 = scar
//31 = zeus
//44 = he
//43 = flash
//45 = smoke
//47 = decoy
//48 = molli
//516 = default knife
//508 = m9
//507 = karambae
//500 = bayonet
//506 = gut
//516 = buttplugs
//505 = flip knife
//509 = huntsman
//512 = falchion
//514 = bowie
//515 = butterfly
//520 = navaja
//522 = stilleto aka craxtos penis
//519 = ursus
//523 = talon
//503 = classic
//517 = paracord
//521 = surv
//518 = nomad
//525 = skeleton

void forentity(Entity@ entiy){
	entiy.read_prop("DT_CSPlayer", "m_hMyWeapons", test_weapon);
}

bool create_move(UserCmd &inout cmd, bool&out sendpacket){
    CSPlayer@ local_player = get_local_player();
    local_health = local_player.health;
    local_armor = local_player.m_ArmorValue();
    Vector3 test_velo = local_player.velocity;
	speed = test_velo.length2d();
    final_speed = speed;
    @local_weapon = local_player.get_weapon();
    cur_weapon = local_weapon.item_definition_index();
    float red = 255 - (local_health*2);
    float green = local_health*2.55;
    //red = red / 255;
    //green = green / 255;
    health = Color(red, green, 0, 255);
    //money m_iAccount 
    //ammo m_iAmmo 
    local_player.read_prop("DT_CSPlayer", "m_iAmmo", local_ammo);
    local_player.read_prop("DT_CSPlayer", "m_iAccount", local_money);
    CSGO_Weapon_ID[508] = "M9 Bayonet";

    return true;
}

/*     weapons = {"Desert Eagle", "Dual Berettas", "Five-SeveN"};
    weapons[8] = "AUG";
    weapons[9] = "AWP";
    weapons[10] = "FAMAS";
    weapons[14] = "M249";
    weapons[16] = "M4A4";
    weapons[19] = "P90";
    weapons[23] = "MP5-SD";
    weapons[24] = "UMP-45";
    weapons[25] = "XM1014";
    weapons[26] = "PP-Bizon";
    weapons[27] = "MAG-7";
    weapons[28] = "Negev";
    weapons[31] = "Zeus";
    weapons[34] = "MP9";
    weapons[35] = "Nova";
    weapons[36] = "P250";
    weapons[38] = "SCAR-20";
    weapons[40] = "SSG-08";
    weapons[43] = "Flashbang";
    weapons[44] = "High Explosive Grenade";
    weapons[45] = "Smoke Grenade";
    weapons[47] = "Decoy Grenade";
    weapons[48] = "Molotov"; //Team check
    weapons[60] = "M4A1-S";
    weapons[61] = "USP-S";
    weapons[500] = "Bayonet";
    weapons[503] = "Classic Knife";
    weapons[505] = "Flip Knife";
    weapons[506] = "Gut Knife";
    weapons[507] = "Karambit";
    weapons[508] = "M9 Bayonet";
    weapons[509] = "Huntsman Knife";
    weapons[512] = "Falchion Knife";
    weapons[514] = "Bowie Knife";
    weapons[515] = "Butterfly Knife";
    weapons[516] = "Shadow Daggers";
    weapons[517] = "Paracord Knife";
    weapons[518] = "Nomad Knife";
    weapons[519] = "Ursus Knife";
    weapons[520] = "Navaja Knife";
    weapons[521] = "Survival Knife";
    weapons[522] = "Stilleto"; //craxto pp
    weapons[523] = "Talon Knife";
    weapons[525] = "Skeleton Knife"; */

array<string> CSGO_Weapon_ID ={
	"None",
	"Desert Eagle",
	"Dual Berettas",
	"Five-SeveN",
	"Glock",
	"weapon_p228",
	"USP-S",
	"AK-47",
	"AUG",
	"AWP",
	"FAMAS",
	"G3SG1",
	"Galil AR",
	"Galil AR",
	"M249",
	"M4A4",
	"M4A1-S",
	"MAC-10",
	"MP5-SD",
	"P90",
	"SSG-08",
	"SSG 550",
	"SSG 553",
	"MP5-SD",
	"UMP-45",
	"XM-1014",
	"PP-Bizon",
	"MAG-7",
	"Negev",
	"Sawed-Off",
	"Tec-9",
	"Zeus x88",
	"P2000",
	"MP7",
	"MP9",
	"Nova",
	"P250",
	"Ballistic Shield",
	"Scar-20",
	"SG 553",
	"SSG 08",
	"Knife",
	"Knife",
	"Flashbang",
	"High Explosive Grenade",
	"Smoke Grenade",
	"Molotov",
	"Decoy Grenade",
	"Incendiary Grenade",
	"C4 Explosive"
};

void drawer(){
    Vector2 screen = screen_size();
    string str_speed = fmt_float("%0.0f", speed);
    string str_health = local_health;
    string str_armor = local_armor;
    string str_money = local_money;
    Vector2 armor_size = text_size("Verdana", str_armor, 1.f); 
    Vector2 health_size = text_size("Verdana", str_health, 1.f);
    Vector2 money_size = text_size("Verdana", str_money, 1.f);
    Vector2 speed_size = text_size("Verdana", str_speed, 1.f);
    draw_text(Vector2((screen.x / 2 - health_size.x / 2) - 125, screen.y / 2 + health_size.y - 10), Vector2(), "Verdana", str_armor, blue, 1, 1.f);
    draw_text(Vector2(screen.x / 2 - speed_size.x / 2, screen.y / 2 + speed_size.y), Vector2(), "Verdana", fmt_float("%0.0f", speed), white, 1, 1.f);
    draw_text(Vector2(screen.x / 2 - money_size.x / 2, screen.y / 2 + money_size.y + speed_size.y ), Vector2(), "Verdana", "$" + str_money, white, 1, 1.f);
    draw_text(Vector2((screen.x / 2 - health_size.x / 2) - 125, screen.y / 2 - 10), Vector2(), "Verdana", str_health, health, 1, 1.f);
}

void on_dr(){
    Vector2 screen = screen_size();
    string str_weapon = CSGO_Weapon_ID[local_weapon.item_definition_index()];
    Vector2 weapon_size = text_size("Verdana", str_weapon, 1.f);
    draw_text(Vector2((screen.x / 2 - weapon_size.x / 2) + 125, screen.y / 2), Vector2(), "Verdana", str_weapon, white, 1, 1.f);
}

bool shutdown(){
    remove_draw_callback("on_dr");
    remove_createmove_callback("create_move");
    remove_draw_callback("on_draw");

    return true;
}

bool initialize(){
    register_draw_callback(on_dr, "on_dr");
    register_draw_callback(drawer, "on_draw");
    register_createmove_callback(create_move, "create_move");
    add_font("Verdana", "C:\\Windows\\Fonts\\verdanab.ttf", 14);

    return true;
}