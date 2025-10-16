{delib, ...}:
delib.module {
    name = "nix-ld";
    options = delib.singleEnableOption true;
    nixos.ifEnabled.programs.nix-ld.enable = true;
}
