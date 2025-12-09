{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "dev.nix";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = with pkgs; [
        alejandra
        nixd
        nix-update
    ];
}
