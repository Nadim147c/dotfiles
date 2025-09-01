{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.gimp";
    options = delib.singleEnableOption host.isDesktop;
    home.ifEnabled.home.packages = [pkgs.gimp3-with-plugins];
}
