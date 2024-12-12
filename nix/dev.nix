{ config, pkgs, ... }:

{
  programs.mise.enable = true;

  home.packages = with pkgs; [
    # LS & Formater
    nixd
    alejandra
    unzip

    # CLI
    gh
    git
    gnumake
    sccache

    # Tools
    zellij
    neovim
    mise
  ];

  home.file = {
    ".config/nvim".source = ../config/nvim;
    ".config/kitty".source = ../config/kitty;
    ".config/zellij".source = ../config/zellij;
    ".gitconfig".source = ../config/.gitconfig;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    RUSTC_WRAPPER = "sccache";

    GOPATH = "$HOME/.local/share/go";
    PNPM_HOME = "$HOME/.local/share/pnpm/";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
    "$HOME/.local/share/pnpm"
    "/usr/local/go/bin"
    "$HOME/.local/share/go/bin/"
  ];
}
