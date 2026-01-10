{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.inkscape";
  options = delib.singleEnableOption host.mediaFeatured;
  home.ifEnabled.home.packages = [ pkgs.inkscape ];
}
