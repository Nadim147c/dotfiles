{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.lua";

    options = delib.singleEnableOption true;

    home.ifEnabled.home.packages = with pkgs; [
        lua-language-server
        stylua
    ];
}
