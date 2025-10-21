{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.btop";
    options = delib.singleEnableOption host.cliFeatured;
    home.ifEnabled.programs.btop = {
        enable = true;
        settings = {
            theme_background = false;
            vim_keys = true;
            update_ms = 200;
        };
    };
}
