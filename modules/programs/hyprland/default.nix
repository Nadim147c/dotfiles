{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.hyprland";

    options = {myconfig, ...} @ args: delib.singleEnableOption myconfig.host.isDesktop args;

    nixos.ifEnabled.programs.hyprland.enable = true;
    nixos.ifEnabled.environment.variables = {
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        GDK_BACKEND = "wayland,x11,*";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";

        XDG_MENU_PREFIX = "arch-";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
    };
    home.ifEnabled.wayland.windowManager.hyprland.enable = true;
    home.ifEnabled.home.packages = with pkgs; [wl-clipboard hyprcursor];
    home.ifEnabled.services.hyprpolkitagent.enable = true;
}
