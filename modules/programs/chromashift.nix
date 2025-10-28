{
    inputs,
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.chromashift";

    options = delib.singleEnableOption host.cliFeatured;

    home.always.imports = [inputs.chromashift.homeModules.default];
    home.ifEnabled.programs.chromashift = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
    };
}
