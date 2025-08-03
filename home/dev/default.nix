{
    pkgs,
    config,
    ...
}: let
    commonShellIntegration = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
    };
in {
    imports = [
        ./git.nix
        ./tmux.nix
        ./alacritty.nix
    ];

    home.packages = with pkgs; [
        alejandra
        aria2
        cava
        coreutils-full
        fd
        ffmpeg
        ffmpegthumbnailer
        findutils
        fzf
        gallery-dl
        git-extras
        gnumake
        less
        neovim
        nixd
        ripgrep-all
        ripgrep
        sd
        skim
        yt-dlp

        chromashift
        git-sb
        image-detect
        dunst-mode-cycle
    ];

    home.sessionVariables = {
        LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-mocha)";
    };

    home.file.".config/npm/npmrc".text = ''
        prefix=$\{XDG_DATA_HOME}/npm
        cache=$\{XDG_CACHE_HOME}/npm
        init-module=$\{XDG_CONFIG_HOME}/npm/config/npm-init.js
        logs-dir=$\{XDG_STATE_HOME}/npm/logs
        color=true
    '';

    home.file.".config/zellij".source = ../static/zellij;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        history.path = "${config.home.homeDirectory}/.local/share/zsh/history";
        history.ignoreSpace = true;
    };
    programs.bash = {
        enable = true;
        enableCompletion = true;
        historyFile = "${config.home.homeDirectory}/.local/share/bash/history";
    };
    programs.fish = {
        enable = true;
        shellInit = builtins.readFile ../static/fish/config.fish;
        generateCompletions = false;
    };

    programs.fzf = {
        enable = true;
        defaultOptions = ["--border" "--ansi" "--layout=reverse"];
        defaultCommand = "fd --type f --color=always";
    };

    home.file.".config/starship.toml".source = ../static/starship/starship.toml;
    home.file.".config/atuin/config.toml".source = ../static/atuin/config.toml;
    programs.starship = commonShellIntegration;
    programs.carapace = commonShellIntegration;
    programs.mise = commonShellIntegration;
    programs.atuin = commonShellIntegration;

    programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = false;
        options = ["--cmd=cd"];
    };

    programs.eza = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = false;
        icons = "auto";
    };

    programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [batman];
    };
}
