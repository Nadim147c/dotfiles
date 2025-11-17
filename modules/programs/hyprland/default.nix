{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "programs.hyprland";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled = {
        programs.hyprland.withUWSM = true;
        programs.hyprland.enable = true;
        environment.variables = {
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
            XDG_MENU_PREFIX = "arch-";
            XDG_CURRENT_DESKTOP = "Hyprland";
            XDG_SESSION_TYPE = "wayland";
            XDG_SESSION_DESKTOP = "Hyprland";
        };
    };
    home.ifEnabled = {
        wayland.windowManager.hyprland.enable = true;
        wayland.windowManager.hyprland.systemd.enable = false;
        home.packages = with pkgs; [wl-clipboard hyprcursor playerctl];
        services.hyprpolkitagent.enable = true;
    };
}
