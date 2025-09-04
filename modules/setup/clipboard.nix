{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "setup.clipboard";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled.home.packages = with pkgs; [
        cliphist
        nwg-clipman
        wl-clipboard
    ];
    home.ifEnabled.services.cliphist = {
        enable = true;
        allowImages = true;
    };
}
