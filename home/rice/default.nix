{
    pkgs,
    config,
    lib,
    ...
}: {
    imports = [
        ./waybar
        ./fastfetch.nix
        ./rong.nix
    ];

    home.packages = with pkgs; [
        fastfetch
        adw-gtk3
        adwaita-icon-theme
        dust
        waypaper

        # Eww doesn't work as intented. For now, I'm using native arch package
        # eww
        gtk3
        gtk4
        gtk4-layer-shell
        zellij
        nwg-look
        # These support packages doesn't work properly with dynamic theme
        # I'm using these native arch packages for them
        # qt6ct
        # kdePackages.dolphin-plugins
        # kdePackages.dolphin

        kdePackages.breeze-icons

        desktop-portal-starter
        wallpaper-sh
        compile-scss
        waybar-lyric
        waybar-reload
        go-modules
    ];

    catppuccin.flavor = "mocha";
    catppuccin.bat.enable = true;
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

    # Change waypaper config which can be modified by waypaper itself
    home.activation.waypaperConfig = let
        waypaperConfig = ''
            [Settings]
            language = en
            folder = ${config.home.homeDirectory}/Pictures/Wallpapers/
            monitors = All
            post_command = ${pkgs.wallpaper-sh}/bin/wallpaper.sh \$wallpaper
            show_path_in_tooltip = True
            backend = none
            use_xdg_state = True
        '';
    in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "${config.xdg.configHome}/waypaper"
            echo "${waypaperConfig}" > "${config.xdg.configHome}/waypaper/config.ini"
        '';

    xdg.configFile."wofi/style.scss".source = ../static/wofi/style.scss;
    xdg.configFile."wofi/config".source = ../static/wofi/config;
    xdg.configFile."swayosd/style.scss".source = ../static/swayosd/style.scss;

    xdg.configFile."hypr/configs".source = ../static/hypr/configs;
    xdg.configFile."hypr/hyprland.conf".source = ../static/hypr/hyprland.conf;
    xdg.configFile."hypr/hypridle.conf".source = ../static/hypr/hypridle.conf;
    xdg.configFile."hypr/hyprlock.conf".source = ../static/hypr/hyprlock.conf;
    xdg.configFile."hypr/xdph.conf".source = ../static/hypr/xdph.conf;
}
