{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.kdenlive";

    options = delib.singleEnableOption host.mediaFeatured;

    home.ifEnabled.home.packages = [pkgs.kdePackages.kdenlive];
}
