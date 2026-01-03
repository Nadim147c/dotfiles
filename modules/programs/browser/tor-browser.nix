{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.browsers";

  options.programs.browsers.tor = delib.boolOption host.guiFeature;

  home.ifEnabled.home.packages = [ pkgs.tor-browser ];
}
