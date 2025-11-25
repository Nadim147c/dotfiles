{delib, ...}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.wayland.windowManager.hyprland.sourceFirst = true;
    home.ifEnabled.wayland.windowManager.hyprland.settings = {
        source = ["colors.conf"];

        general = {
            gaps_in = 2;
            gaps_out = "0,5,5,5";
            border_size = 2;
            "col.active_border" = "$primary";
            "col.inactive_border" = "$outline";
            layout = "dwindle";
            resize_on_border = true;
        };

        decoration = {
            rounding = 10;
            inactive_opacity = 0.85;
            active_opacity = 0.90;
            fullscreen_opacity = 1.0;

            blur = {
                enabled = true;
                size = 10;
                passes = 3;
                new_optimizations = true;
                ignore_opacity = true;
                xray = false;
                popups = true;
            };

            shadow = {
                enabled = false;
            };
        };
    };
}
