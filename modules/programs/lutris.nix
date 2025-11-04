{
    delib,
    edge,
    host,
    ...
}:
delib.module {
    name = "programs.lutris";

    options = delib.singleEnableOption host.gamingFeatured;

    home.ifEnabled.programs.lutris = {
        enable = true;
        winePackages = with edge; [
            wine
            wine-staging
        ];
        protonPackages = [edge.proton-ge-bin];
        extraPackages = with edge; [
            gamemode
            gamescope
            mangohud
            umu-launcher
            wine
            wine-staging
            winetricks
        ];
    };
}
