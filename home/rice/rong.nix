{...}: {
    programs.rong = {
        enable = true;
        settings = {
            variant = "expressive";
            version = 2021;
            dark = true;
            links = {
                "hyprland.conf" = "~/.config/hypr/colors.conf";
                "colors.lua" = "~/.config/wezterm/colors.lua";
                "spicetify-sleek.ini" = "~/.config/spicetify/Themes/Sleek/color.ini";
                "kitty-full.conf" = "~/.config/kitty/colors.conf";
                "pywalfox.json" = "~/.cache/wal/colors.json";
                "gtk-css.css" = "~/.config/wlogout/colors.css";
                "rofi.rasi" = "~/.config/rofi/config.rasi";
                "ghostty" = "~/.config/ghostty/colors";
                "dunstrc" = "~/.config/dunst/dunstrc";
                "cava.ini" = "~/.config/cava/themes/rong.ini";
                "btop.theme" = "~/.config/btop/themes/rong.theme";
                "colors.tmux" = "~/.config/tmux/colors.conf";

                "colors.scss" = [
                    "~/.config/eww/colors.scss"
                    "~/.config/waybar/colors.scss"
                    "~/.config/swaync/colors.scss"
                    "~/.config/wofi/colors.scss"
                    "~/.config/swayosd/colors.scss"
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

        templates = {
            "colors.tmux.tmpl" = ''set -g mode-style "bg={{ .Secondary }},fg={{ .OnSecondary }}"'';
            "dunstrc.tmpl" =
                # gotmpl
                ''
                    # vim: ft=cfg

                    [global]
                    monitor = 0
                    follow = none
                    width = 350
                    height = (0, 300)
                    origin = top-right
                    offset = (10, 0)
                    scale = 0
                    notification_limit = 20
                    progress_bar = true
                    progress_bar_height = 10
                    progress_bar_frame_width = 1
                    progress_bar_min_width = 40
                    progress_bar_max_width = 70
                    min_icon_size = 40
                    max_icon_size = 70
                    progress_bar_corner_radius = 0
                    progress_bar_corners = all
                    icon_corner_radius = 10
                    icon_corners = all
                    indicate_hidden = yes
                    transparency = 0
                    separator_height = 2
                    padding = 8
                    horizontal_padding = 8
                    text_icon_padding = 0
                    frame_width = 2
                    gap_size = 0
                    separator_color = frame
                    sort = yes
                    font = "Noto Sans" 12
                    line_height = 0
                    markup = full
                    format = "<b>%s</b>\n%b"
                    alignment = left
                    vertical_alignment = center
                    show_age_threshold = 60
                    ellipsize = middle
                    ignore_newline = no
                    stack_duplicates = true
                    hide_duplicate_count = false
                    show_indicators = yes
                    enable_recursive_icon_lookup = true
                    icon_theme = Adwaita
                    icon_position = left
                    icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/
                    sticky_history = yes
                    history_length = 20
                    dmenu = wofi --show dmenu
                    browser = /usr/bin/xdg-open
                    always_run_script = true
                    title = Dunst
                    class = Dunst
                    corner_radius = 16
                    corners = all
                    ignore_dbusclose = false
                    force_xwayland = false
                    force_xinerama = false
                    mouse_left_click = close_current
                    mouse_middle_click = do_action, close_current
                    mouse_right_click = close_all
                    frame_color = "{{ .Outline }}"

                    [experimental]
                    per_monitor_dpi = false

                    [urgency_low]
                    background = "{{ .Surface }}"
                    foreground = "{{ .OnSurface }}"
                    timeout = 10
                    default_icon = dialog-information

                    [urgency_normal]
                    background = "{{ .Background }}"
                    foreground = "{{ .OnBackground }}"
                    timeout = 10
                    override_pause_level = 1
                    default_icon = dialog-information

                    [urgency_critical]
                    background = "{{ .Background }}"
                    foreground = "{{ .OnBackground }}"
                    frame_color = "{{ .Error }}"
                    timeout = 0
                    override_pause_level = 2
                    default_icon = dialog-warning
                '';
        };
    };
}
