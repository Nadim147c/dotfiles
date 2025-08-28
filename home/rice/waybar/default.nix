{
    pkgs,
    lib,
    config,
    ...
}: let
    fork = "${pkgs.hyprland}/bin/hyprctl dispatch exec --";
    notificationMode = pkgs.writeShellScript "notification-mode" ''
        mode=$(${pkgs.dunst}/bin/dunstctl get-pause-level)
        case "$mode" in
        0) echo "" ;;
        1) echo "" ;;
        2) echo "󰒲" ;;
        3) echo "" ;;
        *) echo "$mode" ;;
        esac
    '';
    reload-pkgs = pkgs.writeShellScriptBin "waybar-reload" ''
        if [ "$XDG_CURRENT_DESKTOP" == Hyprland ]; then
            hyprctl layers -j |
                jq -r 'to_entries[].value.levels | to_entries[].value.[] | select(.namespace == "waybar").pid' |
                xargs kill
            hyprctl dispatch exec waybar
            exit
        fi
    '';
    reload = "${reload-pkgs}/bin/waybar-reload";

    screenshot = pkgs.writeShellScript "screenshot" ''
        pkill slurp || ${pkgs.hyprshot}/bin/hyprshot -m ''${1:-region} --raw |
          nixGLIntel ${pkgs.satty}/bin/satty --filename - \
            --output-filename "${config.xdg.userDirs.pictures}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
            --early-exit \
            --actions-on-enter save-to-clipboard \
            --save-after-copy \
            --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
    '';

    lyric = pkgs.writeShellScript "waybar-lyric.sh" ''
        if [ -f "${config.home.homeDirectory}/.local/bin/waybar-lyric" ]; then
            ${config.home.homeDirectory}/.local/bin/waybar-lyric "$@"
        else
            ${pkgs.waybar-lyric}/bin/waybar-lyric "$@"
        fi
    '';
in {
    home.activation.compileWaybarSyle = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.coreutils}/bin/install -Dm466 ${./style.scss} ${config.xdg.configHome}/waybar/style.scss
        ${pkgs.compile-scss}/bin/compile-scss ${config.xdg.configHome}/waybar/style.scss
    '';

    home.packages = [reload-pkgs];

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "bottom";
                position = "top";
                height = 15;
                exclusive = true;
                gtk-layer-shell = true;
                passthrough = false;
                fixed-center = true;
                reload_style_on_change = true;
                margin = "5px 5px 0 5px";
                modules-left = [
                    "hyprland/workspaces"
                    "tray"
                    "custom/lyrics"
                ];
                modules-center = [];
                modules-right = [
                    "network"
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
                        "custom/coffee"
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
                    on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
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
                    on-click = "eww open media --toggle";
                    on-click-middle = "${lyric} play-pause";
                };

                "custom/notification_mode" = {
                    format = "{}";
                    exec = notificationMode;
                    interval = 1;
                    on-click = "${pkgs.dunst-mode-cycle}/bin/dunst-mode-cycle";
                };

                "custom/launcher" = {
                    format = "";
                    tooltip-format = "Open app launcher";
                    on-click = "wofi --show drun";
                };

                "custom/screenshot" = {
                    format = "󰹑";
                    tooltip-format = "Left Click: Capture a region\nMiddle Click: Capture a window\nRight Click: Capture the screen";
                    on-click = "${screenshot} region";
                    on-click-middle = "${screenshot} window";
                    on-click-right = "${screenshot} output";
                };

                "custom/clipboard" = {
                    format = "";
                    tooltip-format = "Open clipboard history";
                    on-click = "kitty --class=clipboard ~/.local/bin/clipboard-history.sh";
                };

                "custom/coffee" = {
                    format = "{}";
                    # TODO: convert to coffee script support three mode
                    exec = "coffee.sh --waybar";
                    return-type = "json";
                    interval = 1;
                    tooltip-format = "Toggle coffee mode";
                    on-click = "coffee.sh --toggle";
                };

                "custom/wallpaper" = {
                    format = "󰸉";
                    tooltip-format = "Open wallpaper changer";
                    on-click = "${fork} ${pkgs.waypaper}/bin/waypaper";
                };

                "custom/menu" = {
                    format = "󰍜";
                    tooltip-format = "Open Control Center";
                    on-click = "eww open control_center --toggle";
                    on-click-middle = "${reload}";
                };
            };
        };
    };
}
