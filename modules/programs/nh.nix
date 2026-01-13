{ delib, ... }:
delib.module {
  name = "programs.nh";

  options = delib.singleEnableOption false;

  home.ifEnabled.programs.nh.enable = true;
  nixos.ifEnabled.programs.nh.enable = true;
}
