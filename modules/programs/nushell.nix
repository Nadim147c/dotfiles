{delib, ...}:
delib.module {
    name = "programs.nushell";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.nushell = {
        enable = true;
        settings.show_banner = false;
    };
}
