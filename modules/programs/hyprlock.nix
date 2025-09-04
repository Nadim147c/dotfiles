{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "programs.hyprlock";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled.security.pam.services.hyprlock.enable = true;
    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) userfullname;
        player = pkgs.writers.writeNu "hyprlock-player" # nu

        ''
            let infos = (
                playerctl -a metadata --format="{{playerName}}»¦«{{title}}»¦«{{artist}}" |
                lines |
                split column '»¦«' player title artist
            )

            mut $info = ($infos | first)

            if ($infos | where player =~ spotify | is-not-empty) {
                $info = ($infos | where player =~ spotify | first)
            }

            if $info == null {
                return
            }

            let icon = match $info.player {
                spotify => "󰓇  " ,
                YoutubeMusic => "󰗃  "
                 _ => "",
            }

            print $"($icon)($info.artist) - ($info.title)"
            return

        '';
    in {
        programs.hyprlock = {
            enable = true;

            sourceFirst = true;
            settings = {
                source = ["colors.conf"];

                "$font" = "Electroharmonix, JetBrainsMono Nerd Font Propo";

                background = {
                    monitor = "";
                    path = "$image";
                    color = "$background";
                    blur_passes = 2;
                    contrast = 1.0;
                    brightness = 0.5;
                    vibrancy = 0.2;
                    vibrancy_darkness = 0.2;
                };

                general = {
                    hide_cursor = false;
                    grace = 0;
                    disable_loading_bar = true;
                };

                input-field = {
                    monitor = "";
                    size = [250 60];
                    outline_thickness = 2;
                    dots_size = 0.2;
                    dots_spacing = 0.35;
                    dots_center = true;
                    outer_color = "$outline";
                    inner_color = "$background";
                    font_color = "$on_background";
                    fade_on_empty = false;
                    fail_color = "$error";
                    check_color = "$primary";
                    rounding = -1;
                    placeholder_text = ''<i><span foreground="$primary_hex">Password</span></i>'';
                    hide_input = false;
                    position = "0, -70";
                    halign = "center";
                    valign = "center";
                };

                label = [
                    # Time label
                    {
                        monitor = "";
                        text = "cmd[update:1000] date +\"%-I:%M%p\"";
                        color = "$on_background";
                        font_size = 95;
                        font_family = "$font";
                        position = "0, 120";
                        halign = "center";
                        valign = "center";
                    }

                    # Date label
                    {
                        monitor = "";
                        text = "cmd[update:1000] date +\"%A, %B %d\"";
                        color = "$primary";
                        font_size = 16;
                        font_family = "$font";
                        position = "0, 50";
                        halign = "center";
                        valign = "center";
                    }

                    # Current song label
                    {
                        monitor = "";
                        text = "cmd[update:1000] ${player}";
                        color = "$on_background";
                        font_size = 12;
                        font_family = "$font";
                        position = "0, 50";
                        halign = "center";
                        valign = "bottom";
                    }

                    # Greeting label
                    {
                        monitor = "";
                        text = "Hi, ${userfullname}";
                        color = "$on_background";
                        font_size = 14;
                        font_family = "$font";
                        position = "0, -10";
                        halign = "center";
                        valign = "center";
                    }
                ];
            };
        };
    };
}
