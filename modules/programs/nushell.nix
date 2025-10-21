{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.nushell";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.programs.nushell = {
        enable = true;
        settings.show_banner = false;
    };
}
