{delib, ...}:
delib.module {
    name = "programs.nh";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.nh.enable = true;
    nixos.ifEnabled.programs.nh.enable = true;
}
