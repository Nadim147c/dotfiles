{delib, ...}:
delib.module {
    name = "programs.eza";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        icons = "auto";
    };
}
