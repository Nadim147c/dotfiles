{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "dev.base";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = with pkgs; [
        bat
        curl
        fd
        fzf
        gnugrep
        gnumake
        htop
        httpie
        neovim
        ripgrep
        sd
        skim
        tmux
        tree
        unzip
        wget
        xh
    ];
}
