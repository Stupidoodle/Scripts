Button@ fake_prime;
Button@ fake_nonprime;

void prime_enabler(){
    run_script("""var waitForPlayerUpdateEventHandler = null;
        if (!LobbyAPI.IsSessionActive()) { 
            LobbyAPI.CreateSession(); 
        }
        function stopCustomEvents() {
            if (waitForPlayerUpdateEventHandler != null) {
                $.UnregisterForUnhandledEvent( 'PanoramaComponent_Lobby_PlayerUpdated', waitForPlayerUpdateEventHandler);
                waitForPlayerUpdateEventHandler = null;
            }
        }
        stopCustomEvents();
        var playerData = {
            update: {
                members: {
                }
            }
        }
        var updateMessage = "";
        if (PartyListAPI.GetXuidByIndex(0) != 0) {
            var machineName = "machine0"
            updateMessage += "Update/Members/" + machineName + "/player0/game/prime 1";
        }
        waitForPlayerUpdateEventHandler = $.RegisterForUnhandledEvent( "PanoramaComponent_Lobby_PlayerUpdated", function(xuid) {
            PartyListAPI.UpdateSessionSettings(updateMessage);
        });
        PartyListAPI.UpdateSessionSettings(updateMessage);
""", "panorama/layout/base.xml");
}

void prime_disabler(){
    run_script("""var waitForPlayerUpdateEventHandler = null;
        if (!LobbyAPI.IsSessionActive()) { 
            LobbyAPI.CreateSession(); 
        }
        function stopCustomEvents() {
            if (waitForPlayerUpdateEventHandler != null) {
                $.UnregisterForUnhandledEvent( 'PanoramaComponent_Lobby_PlayerUpdated', waitForPlayerUpdateEventHandler);
                waitForPlayerUpdateEventHandler = null;
            }
        }
        stopCustomEvents();
        var playerData = {
            update: {
                members: {
                }
            }
        }
        var updateMessage = "";
        if (PartyListAPI.GetXuidByIndex(0) != 0) {
            var machineName = "machine0"
            updateMessage += "Update/Members/" + machineName + "/player0/game/prime 0";
        }
        waitForPlayerUpdateEventHandler = $.RegisterForUnhandledEvent( "PanoramaComponent_Lobby_PlayerUpdated", function(xuid) {
            PartyListAPI.UpdateSessionSettings(updateMessage);
        });
        PartyListAPI.UpdateSessionSettings(updateMessage);
""", "panorama/layout/base.xml");
}

bool initialize() {
    @fake_prime = add_button("Misc", "General", "Scripts - Fake Prime", "Enable Prime", function(){
        prime_enabler(); 
    });
    @fake_nonprime = add_button("Misc", "General", "Scripts - Fake Prime", "Disable Prime", function(){
        prime_disabler();
    });


    return true;
}