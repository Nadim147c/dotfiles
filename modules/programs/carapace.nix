{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.carapace";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.programs.carapace = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
    };
}
