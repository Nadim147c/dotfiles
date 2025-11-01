{
    inputs,
    delib,
    host,
    edge,
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
        # since rong use go 1.25 but nixpkgs stable has go 1.24 use the unstable
        # nixpkgs to build the package
        package = edge.callPackage "${inputs.rong}/default.nix" {};
        settings = {
            dark = true;
            base16 = {
                blend = 0.5;
                method = "static";
            };
            material = {
                contrast = 0.0;
                platform = "phone";
                variant = "tonal_spot";
                version = "2025";
            };
            links = {
                "hyprland.conf" = "~/.config/hypr/colors.conf";
                "colors.lua" = "~/.config/wezterm/colors.lua";
                "spicetify-sleek.ini" = "~/.config/spicetify/Themes/Sleek/color.ini";
                "kitty-full.conf" = "~/.config/kitty/colors.conf";
                "pywalfox.json" = "~/.cache/wal/colors.json";
                "rofi.rasi" = "~/.config/rofi/config.rasi";
                "ghostty" = "~/.config/ghostty/colors";
                "dunstrc" = "~/.config/dunst/dunstrc";
                "cava.ini" = "~/.config/cava/config";
                "btop.theme" = "~/.config/btop/themes/rong.theme";
                "colors.tmux" = "~/.config/tmux/colors.conf";

                "colors.scss" = [
                    "~/.config/eww/colors.scss"
                    "~/.config/waybar/colors.scss"
                    "~/.config/swaync/colors.scss"
                    "~/.config/wofi/colors.scss"
                    "~/.config/swayosd/colors.scss"
                    "~/.config/wlogout/colors.scss"
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
                "midnight-discord.css" = [
                    "~/.config/equibop/settings/quickCss.css"
                    "~/.config/vesktop/settings/quickCss.css"
                    "~/.config/goofcord/GoofCord/assets/rong.css"
                ];
            };
        };
    };
}
