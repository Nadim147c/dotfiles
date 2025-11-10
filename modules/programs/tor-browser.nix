{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.tor-browser";

    options = delib.singleEnableOption host.isPC;

    home.ifEnabled.home.packages = [pkgs.tor-browser];
}
