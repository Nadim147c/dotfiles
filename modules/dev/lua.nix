{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "dev.lua";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = with pkgs; [
        lua-language-server
        stylua
    ];
}
