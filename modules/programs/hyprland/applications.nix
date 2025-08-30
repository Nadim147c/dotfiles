{
    delib,
    inputs,
    lib,
    pkgs,
    ...
}: let
    zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

    browser = lib.getExe zen-browser;
    discord = lib.getExe pkgs.goofcord;
    runner = lib.getExe pkgs.wofi;
    spotify = lib.getExe pkgs.spotify;
    terminal = lib.getExe pkgs.kitty;

    files = "${pkgs.kdePackages.dolphin}/bin/dolphin";
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
                "$dicord" = discord;
                "$files" = files;
                "$runner" = runner;
                "$terminal" = terminal;
                "$music" = spotify;

                exec-once = [
                    "[workspace 1 silent] $terminal"
                    "[workspace 2 silent] $browser"
                    "[workspace 3 silent] $discord"
                    "[workspace 4 silent] $music"
                ];

                bind = [
                    "$mainMod, Q,     exec, $terminal"
                    "$mainMod, B,     exec, $browser"
                    "$mainMod, M,     exec, $music"
                    "$mainMod, E,     exec, $files"
                    "ALT,      SPACE, exec, $runner"
                ];
            };
        };
    }
