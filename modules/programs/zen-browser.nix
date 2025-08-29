{
    delib,
    inputs,
    ...
}:
delib.module {
    name = "programs.zen-browser";

    options = {myconfig, ...} @ args: delib.singleEnableOption myconfig.host.isDesktop args;

    home.always.imports = [inputs.zen-browser.homeModules.beta];
    home.ifEnabled.programs.zen-browser = {
        enable = true;
    };
}
