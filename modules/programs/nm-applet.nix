{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.nm-applet";

    options = delib.singleEnableOption (host.isDesktop && host.guiFeatured);

    nixos.ifEnabled.programs.nm-applet = {
        enable = true;
        indicator = true;
    };
}
