{
    delib,
    pkgs,
    config,
    inputs,
    ...
}:
delib.module {
    name = "programs.waybar";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username};

        dunst-mode-cycle = pkgs.writeShellScript "dunst-mode-cycle" ''
            current=$(dunstctl get-pause-level)

            case "$current" in
            0) next=1 ;;
            1) next=2 ;;
            2) next=3 ;;
            3) next=0 ;;
            *) next=0 ;;
            esac

            dunstctl set-pause-level "$next"
        '';

        notification-mode = pkgs.writeShellScript "notification-mode" ''
            mode=$(${pkgs.dunst}/bin/dunstctl get-pause-level)
            case "$mode" in
            0) echo "" ;;
            1) echo "" ;;
            2) echo "󰒲" ;;
            3) echo "" ;;
            *) echo "$mode" ;;
            esac
        '';

        reload = pkgs.writeShellScript "waybar-reload" ''
            ${pkgs.systemd}/bin/systemctl --user restart waybar.service
        '';

        localLyric = "${home.home.homeDirectory}/.local/bin/waybar-lyric";
        lyric = pkgs.writeShellScript "waybar-lyric.sh" ''
            if [ -f "${localLyric}" ]; then
                exec ${localLyric} "$@"
            else
                exec ${pkgs.waybar-lyric}/bin/waybar-lyric "$@"
            fi
        '';
    in {
        home.activation.compileWaybarSyle = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${pkgs.coreutils}/bin/install -Dm644 ${./style.scss} ${home.xdg.configHome}/waybar/style.scss
            ${pkgs.compile-scss}/bin/compile-scss ${home.xdg.configHome}/waybar/style.scss
        '';

        home.packages = [pkgs.compile-scss];

        programs.waybar = {
            enable = true;
            systemd.enable = true;
            settings = {
                main = {
                    layer = "bottom";
                    position = "top";
                    height = 15;
                    exclusive = true;
                    gtk-layer-shell = true;
                    passthrough = false;
                    fixed-center = true;
                    reload_style_on_change = true;
                    margin = "5px";
                    modules-left = [
                        "hyprland/workspaces"
                        "tray"
                        "custom/lyrics"
                    ];
                    modules-center = [];
                    modules-right = [
                        "network"
                        "cpu"
                        "memory"
                        "wireplumber"
                        "clock"
                        "group/actions"
                        "custom/menu"
                    ];

                    "group/actions" = {
                        orientation = "horizontal";
                        modules = [
                            "privacy"
                            "custom/notification_mode"
                            "custom/launcher"
                            "custom/screenshot"
                            "custom/clipboard"
                            "custom/wallpaper"
                        ];
                    };

                    tray = {
                        spacing = 10;
                    };

                    privacy = {
                        icon-spacing = 4;
                        icon-size = 14;
                        transition-duration = 250;
                        modules = [
                            {
                                type = "screenshare";
                                tooltip-format = true;
                                tooltip-format-icon-size = 24;
                            }
                            {
                                type = "audio-in";
                                tooltip-format = true;
                                tooltip-format-icon-size = 24;
                            }
                        ];
                        ignore-monitor = true;
                        ignore = [
                            {
                                type = "audio-in";
                                name = "cava";
                            }
                            {
                                type = "screenshare";
                                name = "obs";
                            }
                        ];
                    };

                    clock = {
                        format = " {:%I:%M%p}";
                        tooltip = false;
                        on-click = "eww open calendar --toggle";
                    };

                    wireplumber = {
                        format = "{icon} {volume}%";
                        format-muted = "";
                        on-click = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
                        format-icons = ["" "" ""];
                    };

                    network = {
                        format = " {bandwidthTotalBytes}";
                        format-wifi = "  {bandwidthTotalBytes}";
                        format-ethernet = "󰈀 {bandwidthTotalBytes}";
                        format-disconnected = ""; # An empty format will hide the module.
                        tooltip-format = "{ifname} via {gwaddr} 󰊗";
                        tooltip-format-wifi = " {essid} ({signalStrength}%) {bandwidthTotalBytes}";
                        tooltip-format-ethernet = " {ifname} {bandwidthTotalBytes}";
                        tooltip-format-disconnected = "Disconnected";
                        interval = 1;
                        max-length = 50;
                    };

                    cpu.format = " {}%";
                    memory.format = " {}%";

                    "custom/lyrics" = {
                        return-type = "json";
                        format = "{icon} {0}";
                        hide-empty-text = true;
                        format-icons = {
                            playing = "";
                            paused = "";
                            lyric = "";
                            music = "󰝚";
                            no_lyric = "";
                            getting = "";
                        };
                        exec = "${lyric} -qm150 -ffull";
                        on-click = "${lyric} play-pause";
                        on-click-right = "${lyric} seek --lyric 1";
                        on-scroll-up = "${lyric} volume -- +8%";
                        on-scroll-down = "${lyric} volume -- -8%";
                    };

                    "custom/notification_mode" = {
                        format = "{}";
                        interval = 1;
                        exec = notification-mode;
                        on-click = dunst-mode-cycle;
                    };

                    "custom/launcher" = {
                        format = "";
                        tooltip-format = "Open app launcher";
                        on-click = "${pkgs.wofi}/bin/wofi --show drun";
                    };

                    "custom/menu" = {
                        format = "󰍜";
                        tooltip-format = "Open Control Center";
                        on-click = "${pkgs.wlogout}/bin/wlogout -b 5";
                        on-click-middle = reload;
                    };
                };
            };
        };
    };
}
