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

    editor = "${pkgs.neovim}/bin/nvim";
    lessCmd = "${pkgs.less}/bin/less -r -F";

    # fix: for some reason home-manager converts shell variable from sh and set global variable to
    # __HM_SESS_VARS_SOURCED=1 and check this variable before sourcing which makes fish ignore the
    # all there shell variable
    translatedSessionVariables = pkgs.runCommandLocal "hm-session-vars.fish" {} ''
        (echo "function setup_hm_session_vars;"
        echo "set __HM_SESS_VARS_SOURCED" # reset __HM_SESS_VARS_SOURCED so that shell var is set
        ${pkgs.buildPackages.babelfish}/bin/babelfish \
        <${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh
        echo "end"
        echo "setup_hm_session_vars") > $out
    '';
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
        sccache

        chromashift
        git-sb
        image-detect
        dunst-mode-cycle
    ];

    home.sessionVariables = {
        XDG_CONFIG_HOME = config.xdg.configHome;
        XDG_CACHE_HOME = config.xdg.cacheHome;
        XDG_DATA_HOME = config.xdg.dataHome;
        XDG_STATE_HOME = config.xdg.stateHome;

        STARSHIP_CONFIG = "${config.xdg.configHome}/starship.toml";
        WGETRC = "${config.xdg.configHome}/wget/config";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";

        PNPM_HOME = "${config.xdg.dataHome}/pnpm";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
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
    ];

    home.shellAliases = {
        # Aliases
        zk = "zellij kill-all-sessions -y";

        # Core utils aliases
        du = "du -h";
        grep = "grep --color";
        less = "less -r -F";
        exe = "chmod +x";
        cat = "bat";

        # Cd aliases
        rd = "cd -";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # Other aliases
        delta = "delta --line-numbers --hunk-header-decoration-style none";
        ffmpeg = "ffmpeg -hide_banner";

        gaa = "git add -A";
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
        shellInit = builtins.readFile "${translatedSessionVariables}";
        interactiveShellInit =
            # fish
            ''
                set -U fish_greeting
                set fish_color_command blue --bold
                set fish_color_redirection yellow --bold
                set fish_color_option red
                set fish_pager_color_prefix green --bold
                set fish_pager_color_completion blue --bold
                set fish_pager_color_description white --bold
                # Functions
                function field -a n
                    awk "{ print \$$n }"
                end

                ${pkgs.chromashift}/bin/cshift alias fish | source
            '';
        generateCompletions = false;
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
    programs.mise = commonShellIntegration;

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
