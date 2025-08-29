{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.base";

    options = delib.singleEnableOption true;

    home.ifEnabled.home.packages = with pkgs; [
        bat
        curl
        fd
        fzf
        gnugrep
        gnumake
        htop
        neovim
        ripgrep
        sd
        skim
        tmux
        tree
        unzip
        wget
    ];
}
