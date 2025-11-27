{
    delib,
    host,
    ...
}:
delib.module {
    name = "clipboard";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled.services.cliphist = {
        enable = true; # Enable clipse
        allowImages = true;
    };
}
