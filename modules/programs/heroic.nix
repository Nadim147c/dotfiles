{
    delib,
    edge,
    host,
    ...
}:
delib.module {
    name = "programs.heroic";

    options = delib.singleEnableOption host.gamingFeatured;

    home.ifEnabled.home.packages = with edge; [
        cabextract
        p7zip
        heroic
    ];
}
