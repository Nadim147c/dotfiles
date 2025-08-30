{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "gtk";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {
        home.packages = with pkgs; [
            gtk3
            gtk4
            gtk4-layer-shell
        ];

        gtk = {
            enable = true;
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

        dconf.settings."org/gnome/desktop/interface" = {
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
}
