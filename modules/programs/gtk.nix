{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.gtk";

    options = {myconfig, ...} @ args: delib.singleEnableOption myconfig.host.isDesktop args;

    home.ifEnabled = {
        gtk = {
            enable = true;
            cursorTheme = {
                name = "Bibata-Modern-Classic";
                package = pkgs.bibata-cursors;
                size = 22;
            };

            iconTheme = {
                name = "Adwaita-dark";
                package = pkgs.adwaita-icon-theme;
            };

            theme = {
                name = "adw-gtk3-dark";
                package = pkgs.adw-gtk3;
            };

            font = {
                name = "Noto Sans";
                size = 10;
                package = pkgs.noto-fonts;
            };

            gtk3.extraConfig = {
                gtk-application-prefer-dark-theme = 1;
            };

            gtk4.extraConfig = {
                gtk-application-prefer-dark-theme = 1;
            };
        };

        dconf.settings = {
            "org/gnome/desktop/interface" = {
                cursor-theme = "Bibata-Modern-Classic";
                cursor-size = 22;
                icon-theme = "Adwaita-dark";
                gtk-theme = "adw-gtk3-dark";
                color-scheme = "prefer-dark";
                font-name = "Noto Sans 10";
                document-font-name = "Noto Sans 10";
                monospace-font-name = "JetBrainsMono Nerd Font mono 10";
                font-antialiasing = "rgba";
                font-hinting = "full";
            };
        };
    };
}
