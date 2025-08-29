{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.tor-browser";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled.home.packages = [pkgs.tor-browser];
}
