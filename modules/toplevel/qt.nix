{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "qt";

    options = delib.singleEnableOption host.guiFeatured;

    nixos.ifEnabled.environment.variables = {
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    home.ifEnabled = {
        home.packages = with pkgs; [
            libsForQt5.qt5ct
            qt6Packages.qt6ct
            kdePackages.breeze-icons
        ];

        qt = {
            enable = true;
            platformTheme.name = "qt6ct";
        };
    };
}
