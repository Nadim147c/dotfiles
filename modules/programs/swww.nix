{delib, ...}:
delib.module {
    name = "programs.sww";
    options = {myconfig, ...} @ args: delib.singleEnableOption myconfig.host.isDesktop args;
    home.ifEnabled.services.swww.enable = true;
}
