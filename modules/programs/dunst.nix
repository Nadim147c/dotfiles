{
    config,
    delib,
    host,
    lib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.dunst";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        inherit (lib) mkIf;
        home = config.home-manager.users.${username};
        rong = home.programs.rong.enable;
    in {
        xdg.configFile."dunst/dunstrc".target = "rong/templates/dunstrc.tmpl";
        home.packages = with pkgs; [dunst noto-fonts];
        services.dunst.enable = true;
        services.dunst.settings = {
            global = {
                monitor = 0;
                follow = "none";
                width = 350;
                height = "(0, 300)";
                origin = "top-right";
                offset = "(10, 0)";
                scale = 0;
                notification_limit = 20;
                progress_bar = true;
                progress_bar_height = 10;
                progress_bar_frame_width = 1;
                progress_bar_min_width = 40;
                progress_bar_max_width = 70;
                min_icon_size = 40;
                max_icon_size = 70;
                progress_bar_corner_radius = 0;
                progress_bar_corners = "all";
                icon_corner_radius = 10;
                icon_corners = "all";
                indicate_hidden = true;
                transparency = 0;
                separator_height = 2;
                padding = 8;
                horizontal_padding = 8;
                text_icon_padding = 0;
                frame_width = 2;
                gap_size = 0;
                separator_color = "frame";
                sort = true;
                font = "\"Noto Sans\" 12";
                line_height = 0;
                markup = "full";
                format = "<b>%s</b>\n%b";
                alignment = "left";
                vertical_alignment = "center";
                show_age_threshold = 60;
                ellipsize = "middle";
                ignore_newline = false;
                stack_duplicates = true;
                hide_duplicate_count = false;
                show_indicators = true;
                enable_recursive_icon_lookup = true;
                icon_theme = "Adwaita";
                icon_position = "left";
                sticky_history = true;
                history_length = 20;
                dmenu = "${pkgs.wofi}/bin/wofi --show dmenu";
                browser = "/usr/bin/xdg-open";
                always_run_script = true;
                title = "Dunst";
                class = "dunst";
                corner_radius = 16;
                corners = "all";
                ignore_dbusclose = false;
                force_xwayland = false;
                force_xinerama = false;
                mouse_left_click = "close_current";
                mouse_middle_click = "do_action, close_current";
                mouse_right_click = "close_all";
                frame_color = mkIf rong "{{ .Outline }}";
            };

            experimental = {
                per_monitor_dpi = false;
            };

            urgency_low = {
                background = mkIf rong "{{ .Surface }}";
                foreground = mkIf rong "{{ .OnSurface }}";
                timeout = 10;
                default_icon = "dialog-information";
            };

            urgency_normal = {
                background = mkIf rong "{{ .Background }}";
                foreground = mkIf rong "{{ .OnBackground }}";
                timeout = 10;
                override_pause_level = 1;
                default_icon = "dialog-information";
            };

            urgency_critical = {
                background = mkIf rong "{{ .Background }}";
                foreground = mkIf rong "{{ .OnBackground }}";
                frame_color = mkIf rong "{{ .Error }}";
                timeout = 0;
                override_pause_level = 2;
                default_icon = "dialog-warning";
            };
        };
    };
}
