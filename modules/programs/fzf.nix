{
    delib,
    lib,
    ...
}:
delib.module {
    name = "programs.fzf";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        # enableNushellIntegration = true;
        enableZshIntegration = true;
        defaultOptions = ["--border" "--ansi" "--layout=reverse"];
        defaultCommand = "fd --type f --color=always";
        colors.bg = lib.mkForce "";
    };
}
