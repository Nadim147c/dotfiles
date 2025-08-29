{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.tor-browser";

    options = {myconfig, ...} @ args: delib.singleEnableOption myconfig.host.isDesktop args;

    home.ifEnabled.home.packages = [pkgs.tor-browser];
}
