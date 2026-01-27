{
  delib,
  host,
  pkgs,
  ...
}:
let
  hyprland-exec = cmd: "hyprctl dispatch exec ${pkgs.writeShellScript "" cmd}";
  hyprlock-restore = pkgs.writeShellScriptBin "hyprlock-restore" ''
    hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
    pidof hyprlock | xargs -r kill -9 || true
    hyprctl --instance 0 'dispatch exec hyprlock'
  '';
in

delib.module {
  name = "programs.hypridle";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled.home.packages = with pkgs; [
    hyprlock
    libnotify
    hyprlock-restore
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
          on-timeout = hyprland-exec /* bash */ ''
            notify-send 'Locking the session in 5 seconds'
          '';
        }
        {
          timeout = 300;
          on-timeout = hyprland-exec /* bash */ ''
            pidof hyprlock || hyprlock
          '';
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
