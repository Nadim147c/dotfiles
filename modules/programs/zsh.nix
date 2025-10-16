{
    delib,
    lib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.zsh";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        history.path = "${xdg.dataHome}/zsh/history";
        history.ignoreSpace = true;
        initContent = lib.mkOrder 1200 ''
            source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        '';
    };
}
