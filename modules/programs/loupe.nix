{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.loupe";
  options = delib.singleEnableOption host.isDesktop;
  home.ifEnabled.home.packages = [ pkgs.loupe ];
}
