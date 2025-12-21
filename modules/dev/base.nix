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
    gcc
    gnumake
    gnugrep
    htop
    httpie
    ripgrep
    sd
    skim
    sqlite
    tmux
    tree
    unzip
    vhs
    wget
    xh
  ];
}
