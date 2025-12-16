{
  delib,
  lib,
  pkgs,
  ...
}:
let
  uwsm = "${pkgs.uwsm}/bin/uwsm app --";
  runner = "${uwsm} ${lib.getExe pkgs.wofi}";
  terminal = "${uwsm} ${lib.getExe pkgs.kitty}";

  music = "${uwsm} flatpak run com.spotify.Client  --remote-debugging-port=9222 --remote-allow-origins='*'";
in
delib.module {
  name = "programs.hyprland";

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    "$runner" = runner;
    "$terminal" = terminal;
    "$music" = music;

    exec-once = [
      "[workspace 1 silent] sleep 10 && $terminal"
      "[workspace 2 silent] $browser"
      "[workspace 3 silent] $discord"
      "[workspace 4 silent] $music"
    ];

    bind = [
      "$mainMod, Q,     exec, $terminal"
      "$mainMod, B,     exec, $browser"
      "$mainMod, D,     exec, $discord"
      "$mainMod, M,     exec, $music"
      "$mainMod, E,     exec, $files"
      "ALT,      SPACE, exec, $runner"
    ];
  };
}
