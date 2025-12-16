{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.heroic";

  options = delib.singleEnableOption host.gamingFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    cabextract
    p7zip
    heroic
  ];
}
