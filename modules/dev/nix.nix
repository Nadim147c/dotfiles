{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.nix";

    options = delib.singleEnableOption true;

    home.ifEnabled.home.packages = with pkgs; [
        alejandra
        nixd
    ];
}
