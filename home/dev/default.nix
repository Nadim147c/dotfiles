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

    programs.go = {
        enable = true;
        telemetry.mode = "off";
        goPath = "${config.xdg.dataHome}/go";
        goBin = "${config.xdg.dataHome}/go/bin";
    };

    xdg.configFile."wget/config".text = ''
        hsts-file = ${config.xdg.cacheHome}/wget-hsts
    '';

    xdg.configFile."npm/npmrc".text = ''
        prefix=${config.xdg.dataHome}/npm
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
        logs-dir=${config.xdg.stateHome}/npm/logs
        color=true
    '';

    xdg.configFile."zellij".source = ../static/zellij;
    xdg.configFile."zellij".recursive = true;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        history.path = "${config.xdg.dataHome}/zsh/history";
        history.ignoreSpace = true;
    };
    programs.bash = {
        enable = true;
        enableCompletion = true;
        historyFile = "${config.xdg.dataHome}/bash/history";
    };
    programs.fish = {
        enable = true;
        shellInit = builtins.readFile ../static/fish/config.fish;
        interactiveShellInit = ''
            ${pkgs.chromashift}/bin/cshift alias fish | source
        '';
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
