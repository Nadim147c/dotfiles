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

    home.file.".config/eww" = {
        source = ../static/eww;
        recursive = true;
    };

    home.file.".config/nushell".source = ../static/nushell;
    home.file.".config/nushell".recursive = true;

    home.file.".config/wofi/style.scss".source = ../static/wofi/style.scss;
    home.file.".config/wofi/config".source = ../static/wofi/config;
    home.file.".config/swayosd/style.scss".source = ../static/swayosd/style.scss;

    home.file.".config/hypr/configs".source = ../static/hypr/configs;
    home.file.".config/hypr/hyprland.conf".source = ../static/hypr/hyprland.conf;
    home.file.".config/hypr/hypridle.conf".source = ../static/hypr/hypridle.conf;
    home.file.".config/hypr/hyprlock.conf".source = ../static/hypr/hyprlock.conf;
    home.file.".config/hypr/xdph.conf".source = ../static/hypr/xdph.conf;
}
