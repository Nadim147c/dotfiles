{delib, ...}:
delib.module {
    name = "programs.kdeconnect";
    options = delib.singleEnableOption true;
    nixos.ifEnabled.programs.kdeconnect.enable = true;
    home.ifEnabled.services.kdeconnect = {
        enable = true;
        indicator = true;
    };
}
