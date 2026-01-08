{ delib, lib, ... }:

let
  createEnv = a: lib.mapAttrsToList (k: v: "${k},${v}") a;
in
delib.module {
  name = "programs.hyprland";

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    env = createEnv {
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    master.new_status = "master";
    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };

    input = {
      kb_layout = "us,bd";
      kb_variant = ",probhat";
      numlock_by_default = true;
      follow_mouse = 1;
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
      disable_hyprland_logo = true;
      disable_watchdog_warning = true;
      font_family = "JetBrainsMono Nerd font";
      force_default_wallpaper = false;
    };
  };
}
