{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.dolphin";
    options = delib.singleEnableOption host.isDesktop;
    home.ifEnabled.home.packages = with pkgs.kdePackages; [
        dolphin
        kdegraphics-thumbnailers
        ffmpegthumbs
        qtsvg
        kio-admin
        kio-gdrive
        kio-extras
    ];
}
