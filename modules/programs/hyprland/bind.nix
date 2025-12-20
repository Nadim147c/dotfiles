{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind =
      let
        mkShortcut = x: [
          ",F${x}, workspace, ${x}"
          "$mainMod, F${x}, movetoworkspace, ${x}"
          "SHIFT, F${x}, sendshortcut, ,F${x}"
        ];

        indexed =
          builtins.genList (x: builtins.toString (x + 1)) 8
          |> builtins.map mkShortcut
          |> builtins.concatLists;

      in
      indexed
      ++ [
        ", F12, exec, hyprctl switchxkblayout all next"

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
