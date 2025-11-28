{
    delib,
    host,
    xdg,
    ...
}:
delib.module {
    name = "programs.cava";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.programs.cava.enable = true;
    home.ifEnabled.programs.rong.settings.links = {
        "cava.ini" = "${xdg.configHome}/cava/config";
    };
}
