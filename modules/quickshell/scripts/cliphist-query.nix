{
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "cliphist-query";
    partof = "programs.quickshell";
    package = pkgs.buildGoModule {
        pname = "cliphist-query";
        version = "0.0.1";
        src = ../../../src/cliphist-query;
        vendorHash = "sha256-w+rPFzo6cB2DvmYee07EPxYVrWsrGi/dP5G2JAdXccM=";
        subPackages = [];
    };
}
