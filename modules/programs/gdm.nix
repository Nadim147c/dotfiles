{
  constants,
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.gdm";

  options = delib.singleEnableOption host.isDesktop;

  nixos.ifEnabled.services.displayManager = {
    enable = true;
    defaultSession = "hyprland-uwsm";
    autoLogin = {
      enable = true;
      user = constants.username;
    };
    gdm = {
      enable = true;
      wayland = true;
      autoSuspend = true;
      autoLogin.delay = 0;
    };
    sddm.enable = false;
  };
}
