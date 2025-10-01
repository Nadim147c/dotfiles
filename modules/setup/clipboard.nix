{
    delib,
    host,
    pkgs,
    ...
}: let
    clipboard-history = "${pkgs.kitty}/bin/kitty --class=clipboard  ${pkgs.clipse}/bin/clipse";
in
    delib.module {
        name = "setup.clipboard";

        options = delib.singleEnableOption host.isDesktop;

        home.ifEnabled = {
            services.clipse = {
                enable = true; # Enable clipse
                allowDuplicates = false; # Don't allow duplicate entries
                historySize = 10000; # Keep 500 clipboard entries
                imageDisplay.type = "kitty"; # Image preview method
                package = pkgs.clipse;
            };

            wayland.windowManager.hyprland.settings.bind = [
                "$mainMod, V, exec, ${clipboard-history}"
            ];

            programs.waybar.settings.main."custom/clipboard" = {
                format = "";
                tooltip-format = "Open clipboard history";
                on-click = clipboard-history;
            };
        };
    }
