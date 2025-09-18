{
    delib,
    pkgs,
    config,
    inputs,
    ...
}:
delib.module {
    name = "programs.wlogout";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username};
    in {
        home.activation.compileWlogoutSyle = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${pkgs.coreutils}/bin/install -Dm644 ${./style.scss} ${home.xdg.configHome}/wlogout/style.scss
            ${pkgs.compile-scss}/bin/compile-scss ${home.xdg.configHome}/wlogout/style.scss
        '';

        xdg.configFile."wlogout/icons.scss".text = ''
            $lock: "${./lock.png}";
            $logout: "${./logout.png}";
            $reboot: "${./reboot.png}";
            $shutdown: "${./shutdown.png}";
            $suspend: "${./suspend.png}";
        '';

        programs.wlogout = {
            enable = true;
            layout = [
                {
                    label = "lock";
                    action = "loginctl lock-session";
                    text = "Lock";
                    keybind = "l";
                }
                {
                    label = "logout";
                    action = "loginctl terminate-user \$USER";
                    text = "Logout";
                    keybind = "e";
                }
                {
                    label = "suspend";
                    action = "systemctl suspend";
                    text = "Suspend";
                    keybind = "u";
                }
                {
                    label = "reboot";
                    action = "systemctl reboot";
                    text = "Reboot";
                    keybind = "r";
                }
                {
                    label = "shutdown";
                    action = "systemctl poweroff";
                    text = "Shutdown";
                    keybind = "s";
                }
            ];
        };
    };
}
