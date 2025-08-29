{
    config,
    delib,
    ...
}:
delib.module {
    name = "programs.bash";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        xdg = config.home-manager.users.${username}.xdg;
    in {
        programs.bash = {
            enable = true;
            enableCompletion = true;
            historyFile = "${xdg.dataHome}/bash/history";
        };
    };
}
