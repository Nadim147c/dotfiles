{delib, ...}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.wayland.windowManager.hyprland.settings = {
        "$mainMod" = "SUPER";

        master.new_status = "master";
        ecosystem.no_update_news = true;
        gestures.workspace_swipe = false;

        cursor = {
            no_warps = true;
            sync_gsettings_theme = true;
        };

        dwindle = {
            pseudotile = true;
            preserve_split = true;
        };

        misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            font_family = "JetBrainsMono Nerd font";
        };
    };
}
