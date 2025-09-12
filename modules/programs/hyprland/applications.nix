{
    delib,
    inputs,
    lib,
    pkgs,
    ...
}: let
    zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

    uwsm = "${pkgs.uwsm}/bin/uwsm app --";
    browser = "${uwsm} ${lib.getExe zen-browser}";
    discord = "${uwsm} ${lib.getExe pkgs.equibop}";
    runner = "${uwsm} ${lib.getExe pkgs.wofi}";
    terminal = "${uwsm} ${lib.getExe pkgs.kitty}";

    files = "${uwsm} ${pkgs.xfce.thunar}/bin/thunar";
    music = "${uwsm} flatpak run com.spotify.Client  --remote-debugging-port=9222 --remote-allow-origins='*'";
in
    delib.module {
        name = "programs.hyprland";

        home.ifEnabled = {
            home.packages = with pkgs; [
                equibop
                gtk3
                gtk4
                gtk4-layer-shell
                kdePackages.breeze-icons
                kdePackages.dolphin
                kitty
                nwg-look
                qt6ct
                wofi
                zen-browser
            ];

            wayland.windowManager.hyprland.settings = {
                "$mainMod" = "SUPER";

                "$browser" = browser;
                "$discord" = discord;
                "$files" = files;
                "$runner" = runner;
                "$terminal" = terminal;
                "$music" = music;

                exec-once = [
                    "[workspace 1 silent] $terminal"
                    "[workspace 2 silent] $browser"
                    "[workspace 3 silent] $discord"
                    "[workspace 4 silent] $music"
                ];

                bind = [
                    "$mainMod, Q,     exec, $terminal"
                    "$mainMod, B,     exec, $browser"
                    "$mainMod, D,     exec, $discord"
                    "$mainMod, M,     exec, $music"
                    "$mainMod, E,     exec, $files"
                    "ALT,      SPACE, exec, $runner"
                ];
            };
        };
    }
