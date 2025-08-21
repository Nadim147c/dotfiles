{
    pkgs,
    config,
    lib,
    ...
}: let
    commonShellIntegration = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
    };

    editor = "${pkgs.neovim}/bin/nvim";
    lessCmd = "${pkgs.less}/bin/less -r -F";
in {
    imports = [
        ./fish.nix
        ./git.nix
        ./tmux
        ./alacritty.nix
    ];

    home.packages = with pkgs; [
        alejandra
        aria2
        bun
        cava
        chafa
        cmake
        cmatrix
        coreutils-full
        curlFull
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
        ninja
        nixd
        nodejs
        pnpm
        ripgrep
        ripgrep-all
        ruff
        sccache
        sd
        skim
        uv
        yarn
        yq
        yt-dlp

        chromashift
        crop-image
        dunst-mode-cycle
        git-sb
        image-detect
        tmux-sessionizer
    ];

    home.sessionVariables = {
        XDG_CACHE_HOME = config.xdg.cacheHome;
        XDG_CONFIG_HOME = config.xdg.configHome;
        XDG_DATA_HOME = config.xdg.dataHome;
        XDG_STATE_HOME = config.xdg.stateHome;

        STARSHIP_CONFIG = "${config.xdg.configHome}/starship.toml";
        WGETRC = "${config.xdg.configHome}/wget/config";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";

        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        GOBIN = "${config.xdg.dataHome}/go/bin";
        GOPATH = "${config.xdg.dataHome}/go";
        PNPM_HOME = "${config.xdg.dataHome}/pnpm";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";

        # Cache paths
        STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
        GOMODCACHE = "${config.xdg.cacheHome}/go/mod";

        # Editor settings
        EDITOR = editor;
        VISUAL = editor;

        # Pager settings
        LESS = "-r -F";
        PAGER = lessCmd;
        BAT_PAGER = lessCmd;
        DELTA_PAGER = lessCmd;

        # Color settings
        GCC_COLORS = "error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33";
        GREP_COLORS = ":mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40";

        # LS_COLORS from vivid
        LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-mocha)";

        RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
    };

    home.sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
        "${config.xdg.dataHome}/cargo/bin"
        "${config.xdg.dataHome}/pnpm"
        "${config.xdg.cacheHome}/.bun/bin"
        "${config.xdg.dataHome}/go/bin"
    ];

    home.shellAliases = {
        # Aliases
        zk = "zellij kill-all-sessions -y";

        # Core utils aliases
        du = "du -h";
        grep = "grep --color";
        exe = "chmod +x";
        cat = "${pkgs.bat}/bin/bat";
        man = "${pkgs.bat-extras.batman}/bin/batman";

        # Cd aliases
        rd = "cd -";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # Other aliases
        delta = "${pkgs.delta}/bin/delta --line-numbers --hunk-header-decoration-style none";
        ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg -hide_banner";

        gaa = "git add -A";
        tk = "tmux ls | cut -d: -f1 | xargs -r -n1 tmux kill-session -t";
    };

    manual.manpages.enable = true;
    programs.man = {
        enable = true;
        generateCaches = true;
    };

    programs.go = {
        enable = true;
        telemetry.mode = "off";
        goPath = ".local/share/go";
        goBin = ".local/share/go/bin";
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

    programs.tealdeer = {
        enable = true;
        enableAutoUpdates = true;
        settings.updates = {
            auto_update = true;
            auto_update_interval_hours = 100;
        };
    };

    xdg.configFile."zellij".source = ../static/zellij;
    xdg.configFile."zellij".recursive = true;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        history.path = "${config.xdg.dataHome}/zsh/history";
        history.ignoreSpace = true;
        initContent = lib.mkOrder 1200 ''
            source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        '';
    };
    programs.bash = {
        enable = true;
        enableCompletion = true;
        historyFile = "${config.xdg.dataHome}/bash/history";
    };
    programs.nushell = {
        enable = true;
        settings.show_banner = false;
    };

    programs.fzf = {
        enable = true;
        defaultOptions = [
            "--border"
            "--ansi"
            "--layout=reverse"
        ];
        defaultCommand = "fd --type f --color=always";
    };

    home.file.".config/starship.toml".source = ../static/starship/starship.toml;
    programs.starship = commonShellIntegration;
    programs.carapace = commonShellIntegration;

    programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
    };

    programs.zoxide = {
        enable = true;
        enableBashIntegration = false;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        options = ["--cmd=cd"];
    };

    programs.eza = {
        enable = true;
        enableBashIntegration = false;
        enableFishIntegration = true;
        enableZshIntegration = true;
        icons = "auto";
    };

    programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [batman];
    };
}
