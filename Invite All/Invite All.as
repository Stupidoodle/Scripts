Button@ refresh_nearbies = null;
Button@ invite_nearbies = null;
Button@ print_invite = null;
Button@ invite_friends = null;
Slider@ auto_invite = null;

void refresh(){
        run_script("""var collectedSteamIDS = [];
            collectedSteamIDS.push("123");
            PartyBrowserAPI.Refresh();
            var lobbies = PartyBrowserAPI.GetResultsCount();
            for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
                var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
                if (!collectedSteamIDS.includes(xuid)) {
                    if (collectedSteamIDS.includes('123')) {
                        collectedSteamIDS.splice(collectedSteamIDS.indexOf('123'), 1);
                    }
                    collectedSteamIDS.push(xuid);
                    $.Msg(`Adding ${xuid} to the collection..`);
                }
            }
            $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);""", "panorama/layout/base.xml");
}

void invite(){
    run_script("""var lobbies = PartyBrowserAPI.GetResultsCount();
            for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
                var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
                    collectedSteamIDS.push(xuid);
            }
        collectedSteamIDS.forEach(xuid => {
            FriendsListAPI.ActionInviteFriend(xuid, "");
        });""", "panorama/layout/base.xml");
}

void print(){
    run_script("""$.Msg(collectedSteamIDS);""", "panorama/layout/base.xml");
}

void friends_bombe(){
    run_script("""var friends = FriendsListAPI.GetCount();
        for (var id = 0; id < friends; id++) {
            var xuid = FriendsListAPI.GetXuidByIndex(id);
            FriendsListAPI.ActionInviteFriend(xuid, "");
        } """, "panorama/layout/base.xml");
}

void refresher(){
    refresh();
    string autobus = auto_invite.value();

    run_script("""if(collectedSteamIDS.length >= """ + autobus + """){
                    var lobbies = PartyBrowserAPI.GetResultsCount();
            for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
                var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
                    collectedSteamIDS.push(xuid);
            }
        collectedSteamIDS.forEach(xuid => {
            FriendsListAPI.ActionInviteFriend(xuid, "");
        })};""", "panorama/layout/base.xml");
}

bool shutdown() {
    remove_draw_callback("invite_all_test");

    return true;
}

bool initialize() {
    @refresh_nearbies = add_button("Misc", "General", "Scripts - Invite All", "Refresh Nearbies", function(){
        refresh(); 
    });
    @invite_nearbies = add_button("Misc", "General", "Scripts - Invite All", "Invite Nearbies", function(){
        invite(); 
    });
    @print_invite = add_button("Misc", "General", "Scripts - Invite All", "Print invite collection", function(){
        print();
    });
    @invite_friends = add_button("Misc", "General", "Scripts - Invite All", "Invite Friends", function(){
        friends_bombe();
    });

    @auto_invite = add_slider("Misc", "General", "Scripts - Invite All", "Auto Invite", 0, 500);
    auto_invite.format("%0.0f");
    auto_invite.value(25);

    register_draw_callback(refresher, "invite_all_test");
    
    
    return true;

}















