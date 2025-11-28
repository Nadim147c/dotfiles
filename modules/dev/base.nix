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
        curl
        field
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
        vhs
        wget
        xh
    ];
}
