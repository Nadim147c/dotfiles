{delib, ...}:
delib.module {
    name = "setup.nix-ld";
    options = delib.singleEnableOption true;
    nixos.ifEnabled.programs.nix-ld.enable = true;
}
