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

    home.ifEnabled.home.packages = let
        stable = with pkgs; [
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
            wget
            xh
        ];
        latest = with edge; [
            vhs
            neovim
            charm-freeze
        ];
    in
        stable ++ latest;
}
