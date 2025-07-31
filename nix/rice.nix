{pkgs, ...}: {
    home.packages = with pkgs; [
        fastfetch
        adw-gtk3
        adwaita-icon-theme
        eww
        gtk3
        gtk4
        gtk4-layer-shell
        zellij
        kdePackages.breeze-icons
        kdePackages.qt6ct
    ];

    home.file.".config/eww" = {
        source = ../config/eww;
        recursive = true;
    };

    home.file.".config/fastfetch".source = ../config/fastfetch;
    home.file.".config/nushell".source = ../config/nushell;
    home.file.".config/rong".source = ../config/rong;

    home.file.".config/wofi/style.scss".source = ../config/wofi/style.scss;
    home.file.".config/wofi/config".source = ../config/wofi/config;
    home.file.".config/swayosd/style.scss".source = ../config/swayosd/style.scss;

    home.file.".config/hypr/configs".source = ../config/hypr/configs;
    home.file.".config/hypr/hyprland.conf".source = ../config/hypr/hyprland.conf;
    home.file.".config/hypr/hypridle.conf".source = ../config/hypr/hypridle.conf;
    home.file.".config/hypr/hyprlock.conf".source = ../config/hypr/hyprlock.conf;
    home.file.".config/hypr/xdph.conf".source = ../config/hypr/xdph.conf;
}
