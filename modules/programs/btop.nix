{delib, ...}:
delib.module {
    name = "programs.btop";
    options = delib.singleEnableOption true;
    home.ifEnabled.programs.btop.enable = true;
}
