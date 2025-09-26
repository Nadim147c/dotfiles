{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.wayland.windowManager.hyprland.sourceFirst = true;
    home.ifEnabled.wayland.windowManager.hyprland.settings = {
        source = ["colors.conf"];

        exec = [
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size 22"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme 'Adwaita-dark'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-name 'Noto Sans 10'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 10'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font mono 10'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'"
            "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-hinting 'full'"
        ];

        general = {
            gaps_in = 2;
            gaps_out = "0,5,5,5";
            border_size = 2;
            "col.active_border" = "$primary $secondary 45deg";
            "col.inactive_border" = "$on_primary $on_secondary 45deg";
            layout = "dwindle";
            resize_on_border = true;
        };

        decoration = {
            rounding = 10;
            inactive_opacity = 0.85;
            active_opacity = 0.90;
            fullscreen_opacity = 1.0;

            blur = {
                enabled = true;
                size = 10;
                passes = 3;
                new_optimizations = true;
                ignore_opacity = true;
                xray = false;
                popups = true;
            };

            shadow = {
                enabled = false;
            };
        };
    };
}
