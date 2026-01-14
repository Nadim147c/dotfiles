{
  constants,
  delib,
  pkgs,
  host,
  lib,
  ...
}:
delib.module {
  name = "login-manager";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    services.greetd =
      let
        session = {
          user = constants.username;
          command = "${lib.getExe pkgs.uwsm} start hyprland.desktop";
        };
      in
      {
        enable = true;
        # do not restart on session exit (useful on autologin)
        restart = false;
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };

  };
}
