{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.lutris";

  options = delib.singleEnableOption host.gamingFeatured;

  home.ifEnabled.programs.lutris = {
    enable = true;
    winePackages = with pkgs; [
      wine
      wine-staging
    ];
    protonPackages = [ pkgs.proton-ge-bin ];
    extraPackages = with pkgs; [
      gamemode
      gamescope
      mangohud
      umu-launcher
      wine
      wine-staging
      winetricks
    ];
  };
}
