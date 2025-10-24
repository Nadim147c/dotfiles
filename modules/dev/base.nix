{
    delib,
    edge,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "dev.base";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages =
        (with pkgs; [
            bat
            curl
            fd
            fzf
            gnugrep
            gnumake
            htop
            httpie
            ripgrep
            sd
            skim
            tmux
            tree
            unzip
            vhs
            wget
            xh
        ])
        ++ (with edge; [neovim]);
}
