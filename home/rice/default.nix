{pkgs, ...}: {
    imports = [
        ./fastfetch.nix
        ./rong.nix
    ];

    home.packages = with pkgs; [
        fastfetch
        adw-gtk3
        adwaita-icon-theme
        # Eww doesn't work as intented. For now, I'm using native arch package
        # eww
        gtk3
        gtk4
        gtk4-layer-shell
        zellij
        qt6ct
        nwg-look
        kdePackages.dolphin-plugins
        kdePackages.dolphin
        kdePackages.breeze-icons
        kdePackages.qt6ct
        wallpaper-sh
        compile-scss
        waybar-lyric
        go-modules
    ];

    catppuccin.flavor = "mocha";
    catppuccin.bat.enable = true;
    catppuccin.cava.enable = true;
    catppuccin.bottom.enable = true;

    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            kdePackages.xdg-desktop-portal-kde
        ];
        config = {
            common = {
                default = ["hyprland" "kde"];
            };
        };
    };

    gtk.cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 22;
    };

    xdg.configFile."eww" = {
        source = ../static/eww;
        recursive = true;
    };

    xdg.configFile."nushell".source = ../static/nushell;
    xdg.configFile."nushell".recursive = true;

    xdg.configFile."wofi/style.scss".source = ../static/wofi/style.scss;
    xdg.configFile."wofi/config".source = ../static/wofi/config;
    xdg.configFile."swayosd/style.scss".source = ../static/swayosd/style.scss;

    xdg.configFile."hypr/configs".source = ../static/hypr/configs;
    xdg.configFile."hypr/hyprland.conf".source = ../static/hypr/hyprland.conf;
    xdg.configFile."hypr/hypridle.conf".source = ../static/hypr/hypridle.conf;
    xdg.configFile."hypr/hyprlock.conf".source = ../static/hypr/hyprlock.conf;
    xdg.configFile."hypr/xdph.conf".source = ../static/hypr/xdph.conf;
}
