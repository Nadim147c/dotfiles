{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "setup.cursor";

    options.setup.cursor = {
        enable = delib.boolOption host.isDesktop;
        name = delib.strOption "Bibata-Modern-Classic";
        package = delib.packageOption pkgs.bibata-cursors;
        size = delib.intOption 22;
    };

    home.ifEnabled = {cfg, ...}: {
        home.pointerCursor = {
            enable = true;
            gtk.enable = true;
            hyprcursor.enable = true;

            inherit (cfg) name package size;
        };
    };
}
