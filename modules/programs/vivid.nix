{delib, ...}:
delib.module {
    name = "programs.vivid";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.vivid = {
        enable = true;
        activeTheme = "catppuccin-mocha";
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
    };
}
