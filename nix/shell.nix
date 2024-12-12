{pkgs, ...}: {
  home.packages = with pkgs; [
    # Shell apps
    vivid
    atuin
    eza
    zoxide
    starship
    fastfetch

    # Important apps
    ripgrep
    bat
    fzf
    fd
    btop

    # QOL
    bat-extras.batman
    bat-extras.batdiff
    git-extras
    delta
  ];

  home.file = {
    ".config/starship.toml".source = ../config/starship.toml;

    ".config/zsh".source = ../config/zsh;
    ".config/atuin".source = ../config/atuin;
    ".config/fastfetch".source = ../config/fastfetch;
  };

  home.sessionVariables = {
    GCC_COLORS = "error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33";
    GREP_COLORS = ":mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40";

    PAGER = "less - r - F";
    LESS = "-r - F";
    BAT_PAGER = "less - r - F";
    DELTA_PAGER = "less - r - F";

    FZF_DEFAULT_OPTS = ''
      --color=fg:#cdd6f4,header:#f9e2af,info:#94e2d5,pointer:#f5e0dc
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
      --layout reverse
    '';
  };

  home.sessionPath = [
    "$HOME/.spicetify"
    "$HOME/.local/bin"
  ];

  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.zoxide.options = ["--cmd" "cd"];

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    initExtra = "source \"$HOME/.config/zsh/init.zsh\"";
    shellAliases = {
      hms = "home-manager switch --flake ~/git/dotfiles#ephemeral";
    };
  };
}
