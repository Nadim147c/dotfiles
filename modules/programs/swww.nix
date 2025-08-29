{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.swww";
    options = delib.singleEnableOption host.isDesktop;
    home.ifEnabled.services.swww.enable = true;
}
