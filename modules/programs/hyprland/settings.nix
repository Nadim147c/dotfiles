{ delib, ... }:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    master.new_status = "master";
    ecosystem.no_update_news = true;

    input = {
      numlock_by_default = true;
      kb_layout = "us";
      follow_mouse = 2;
      mouse_refocus = false;
      sensitivity = 0;
      touchpad.natural_scroll = false;
    };

    cursor = {
      no_warps = true;
      sync_gsettings_theme = true;
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      disable_autoreload = true;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      font_family = "JetBrainsMono Nerd font";
    };
  };
}
