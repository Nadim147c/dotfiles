{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.wayland.windowManager.hyprland.settings = {
        "$mainMod" = "SUPER";

        bind = [
            "$mainMod, X, killactive"
            "$mainMod+SHIFT, X, forcekillactive"
            "$mainMod, F, togglefloating"
            "$mainMod+SHIFT, F, fullscreen"
            "$mainMod, G, togglegroup"
            "$mainMod, N, togglesplit"
            "$mainMod, H, movefocus, l"
            "$mainMod, L, movefocus, r"
            "$mainMod, K, movefocus, u"
            "$mainMod, J, movefocus, d"
            "$mainMod+ALT, H, swapwindow, l"
            "$mainMod+ALT, L, swapwindow, r"
            "$mainMod+ALT, K, swapwindow, u"
            "$mainMod+ALT, J, swapwindow, d"

            # Workspace switching
            ",F1, workspace, 1"
            ",F2, workspace, 2"
            ",F3, workspace, 3"
            ",F4, workspace, 4"
            ",F5, workspace, 5"
            ",F6, workspace, 6"
            ",F7, workspace, 7"
            ",F8, workspace, 8"

            # Move to workspace
            "$mainMod, F1, movetoworkspace, 1"
            "$mainMod, F2, movetoworkspace, 2"
            "$mainMod, F3, movetoworkspace, 3"
            "$mainMod, F4, movetoworkspace, 4"
            "$mainMod, F5, movetoworkspace, 5"
            "$mainMod, F6, movetoworkspace, 6"
            "$mainMod, F7, movetoworkspace, 7"
            "$mainMod, F8, movetoworkspace, 8"

            "$mainMod, F9, dpms, toggle"
            "$mainMod, F10, exec, hyprctl reload"
            "$mainMod, F11, exec, dunst-mode-cycle.sh"

            "$mainMod, mouse_down, workspace, e-1"
            "$mainMod, mouse_up, workspace, e+1"
        ];

        bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
            ", XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ", XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
            ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"

            "$mainMod, UP,    exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"
            "$mainMod, DOWN,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        ];

        bindl = [
            ", XF86AudioNext,  exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay,  exec, playerctl play-pause"
            ", XF86AudioPrev,  exec, playerctl previous"

            "$mainMod, RIGHT, exec, ${pkgs.playerctl}/bin/playerctl next"
            "$mainMod, LEFT,  exec, ${pkgs.playerctl}/bin/playerctl previous"
        ];
    };
}
