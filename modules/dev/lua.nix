{
    delib,
    edge,
    host,
    ...
}:
delib.module {
    name = "dev.lua";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = with edge; [
        lua-language-server
        stylua
    ];
}
