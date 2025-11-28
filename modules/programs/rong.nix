{
    inputs,
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.rong";

    options = delib.singleEnableOption host.isDesktop;

    home.always.imports = [inputs.rong.homeModules.default];

    # Redirect
    home.ifEnabled.xdg.configFile = {
        "gtk-4.0/gtk.css".target = "gtk-4.0/gtk.css.ignored";
    };

    home.ifEnabled.programs.rong = {
        enable = true;
        settings = {
            dark = true;
            preview-format = "jpg";
            base16 = {
                blend = 0.5;
                method = "static";
            };
            material = {
                contrast = 0.0;
                platform = "phone";
                variant = "expressive";
                version = "2025";
            };
            links = {
                "hyprland.conf" = "~/.config/hypr/colors.conf";
                "spicetify-sleek.ini" = "~/.config/spicetify/Themes/Sleek/color.ini";
                "kitty-full.conf" = "~/.config/kitty/colors.conf";
                "ghostty-full" = "~/.config/ghostty/themes/rong";
                "dunstrc" = "~/.config/dunst/dunstrc";
                "btop.theme" = "~/.config/btop/themes/rong.theme";

                "colors.scss" = [
                    "~/.config/eww/colors.scss"
                    "~/.config/waybar/colors.scss"
                    "~/.config/swaync/colors.scss"
                    "~/.config/wofi/colors.scss"
                    "~/.config/swayosd/colors.scss"
                    "~/.config/wlogout/colors.scss"
                    "~/.config/walker/themes/colors.scss"
                ];

                "qtct.colors" = [
                    "~/.config/qt5ct/colors/rong.colors"
                    "~/.config/qt6ct/colors/rong.colors"
                ];

                "qtct.conf" = [
                    "~/.config/qt5ct/colors/rong.conf"
                    "~/.config/qt6ct/colors/rong.conf"
                ];

                "gtk.css" = [
                    "~/.config/gtk-3.0/gtk.css"
                    "~/.config/gtk-4.0/gtk.css"
                ];
            };
        };
    };
}
