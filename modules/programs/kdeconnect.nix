{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.kdeconnect";
    options = delib.singleEnableOption host.isDesktop;
    nixos.ifEnabled.programs.kdeconnect.enable = true;
    home.ifEnabled.services.kdeconnect = {
        enable = true;
        indicator = true;
    };
}
