{ delib, ... }:
delib.module {
  name = "programs.man";

  options = delib.singleEnableOption true;

  nixos.ifEnabled = {
    documentation.man = {
      enable = true;
      man-db.enable = true;
      generateCaches = true;
    };
  };
  home.ifEnabled = {
    manual.manpages.enable = true;
    programs.man = {
      enable = true;
      generateCaches = true;
    };
  };
}
