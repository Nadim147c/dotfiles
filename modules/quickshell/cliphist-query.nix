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
        src = ../../src/cliphist-query;
        vendorHash = "sha256-W0O70AYE9kI7PBqtA2VPz5oFx0uApuugy70essCf1so=";
        subPackages = [];
    };
}
