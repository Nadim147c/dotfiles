{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.gdm";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
    in {
        services.displayManager = {
            gdm = {
                enable = true;
                settings = {};
                debug = false;
                wayland = true;
                autoSuspend = true;
                autoLogin.delay = 0;
            };
            defaultSession = "hyprland-uwsm";
            autoLogin = {
                enable = true;
                user = username;
            };
        };
    };
}
