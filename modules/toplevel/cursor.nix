{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "cursor";

    options = delib.moduleOptions (with delib; {
        enable = boolOption host.isDesktop;
        name = strOption "Bibata-Modern-Classic";
        package = packageOption pkgs.bibata-cursors;
        size = intOption 22;
    });

    home.ifEnabled = {cfg, ...}: {
        home.pointerCursor = {
            enable = true;
            gtk.enable = true;
            hyprcursor.enable = true;

            inherit (cfg) name package size;
        };
    };
}
