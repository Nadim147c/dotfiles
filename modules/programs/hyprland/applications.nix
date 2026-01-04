{
  delib,
  lib,
  pkgs,
  func,
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

  home.ifEnabled =
    { myconfig, ... }:
    let
      primaryDisaply =
        myconfig.displays
        |> lib.attrValues
        |> lib.findFirst (x: x.primary) {
          width = 1980;
          height = 1080;
        };
      str = x: func.round x |> toString;
      size = "${str (primaryDisaply.width * 0.7)} ${str (primaryDisaply.height * 0.7)}";
    in
    {
      wayland.windowManager.hyprland.settings = {
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
          "$mainMod, E,     exec, [size ${size}] $files"
          "ALT,      SPACE, exec, $runner"
        ];
      };

    };
}
