{
  delib,
  host,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) escapeShellArg;
  hyprland-exec = cmd: "hyprctl dispatch exec ${escapeShellArg cmd}";
in
delib.module {
  name = "programs.hypridle";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled.home.packages = with pkgs; [
    hyprlock
    libnotify
  ];
  home.ifEnabled.services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = hyprland-exec "pidof hyprlock || hyprlock";
        before_sleep_cmd = hyprland-exec "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 295;
          on-timeout = hyprland-exec "notify-send 'Locking the session in 5 seconds'";
        }
        {
          timeout = 300;
          on-timeout = hyprland-exec "pidof hyprlock || hyprlock";
        }
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
