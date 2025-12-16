{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.uwsm";

  options = delib.singleEnableOption host.isDesktop;

  nixos.ifEnabled.programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };
}
