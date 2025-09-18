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
        nix.settings = {
            substituters = ["https://hyprland.cachix.org"];
            trusted-substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        };

        programs.hyprland.withUWSM = true;
        programs.hyprland.enable = true;
        environment.variables = {
            QT_QPA_PLATFORM = "wayland;xcb";
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            QT_QPA_PLATFORMTHEME = "qt6ct";

            GTK_THEME = "adw-gtk3-dark";

            GDK_BACKEND = "wayland,x11,*";
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
        home.packages = with pkgs; [wl-clipboard hyprcursor playerctl];
        services.hyprpolkitagent.enable = true;
    };
}
