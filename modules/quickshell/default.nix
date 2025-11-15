{
    delib,
    inputs,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.quickshell";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = let
        quickshell = inputs.quickshell.packages.${pkgs.system}.default;
        netspeed = pkgs.buildGoModule {
            pname = "netspeed";
            version = "0.0.1";
            src = ../../src/netspeed;
            vendorHash = null;
            subPackages = [];
        };
    in [
        quickshell
        netspeed
        pkgs.kdePackages.qtdeclarative
    ];
}
