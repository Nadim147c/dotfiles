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
    discord = "${uwsm} ${lib.getExe pkgs.goofcord}";
    runner = "${uwsm} ${lib.getExe pkgs.wofi}";
    music = "${uwsm} ${lib.getExe pkgs.spotify}";
    terminal = "${uwsm} ${lib.getExe pkgs.kitty}";

    files = "${uwsm} ${pkgs.xfce.thunar}/bin/thunar";
in
    delib.module {
        name = "programs.hyprland";

        home.ifEnabled = {
            home.packages = with pkgs; [
                goofcord
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
