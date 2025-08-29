{
    config,
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.wget";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username};
    in {
        home.packages = [pkgs.wget];
        xdg.configFile."wget/config".text = ''
            hsts-file = ${home.xdg.cacheHome}/wget-hsts
        '';
    };
}
