{
    delib,
    host,
    inputs,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.wlogout";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled = {
        home.activation.compileWlogoutSyle = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${pkgs.coreutils}/bin/install -Dm644 ${./style.scss} ${xdg.configHome}/wlogout/style.scss
            ${pkgs.compile-scss}/bin/compile-scss ${xdg.configHome}/wlogout/style.scss
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
                    action = pkgs.writeShellScript "graceful-reboot.sh" ''
                        hyprctl clients -j |
                            ${pkgs.jq}/bin/jq -r '.[] | "address:\(.address)"' |
                            ${pkgs.findutils}/bin/xargs -n1 hyprctl dispatch closewindow &&
                            sleep 2.5
                        systemctl reboot
                    '';
                    text = "Reboot";
                    keybind = "r";
                }
                {
                    label = "shutdown";
                    action = pkgs.writeShellScript "graceful-shutdown.sh" ''
                        hyprctl clients -j |
                            ${pkgs.jq}/bin/jq -r '.[] | "address:\(.address)"' |
                            ${pkgs.findutils}/bin/xargs -n1 hyprctl dispatch closewindow &&
                            sleep 2.5
                        systemctl poweroff
                    '';
                    text = "Shutdown";
                    keybind = "s";
                }
            ];
        };
    };
}
