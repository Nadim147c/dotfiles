{
    config,
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "setup.shell";
    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        xdg = config.home-manager.users.${username}.xdg;
        home = config.home-manager.users.${username}.home;
        editor = "${pkgs.neovim}/bin/nvim";
        lessCmd = "${pkgs.less}/bin/less -r -F";
    in {
        home.packages = with pkgs; [
            aria2
            btop
            cava
            chafa
            cmatrix
            coreutils-full
            crop-image
            ffmpeg
            findutils
            fork
            fzf
            gallery-dl
            image-detect
            jq
            killall
            less
            procps
            ripgrep
            ripgrep-all
            wtf
            xxHash
            yq
        ];

        home.sessionVariables = {
            XDG_CACHE_HOME = xdg.cacheHome;
            XDG_CONFIG_HOME = xdg.configHome;
            XDG_DATA_HOME = xdg.dataHome;
            XDG_STATE_HOME = xdg.stateHome;

            WGETRC = "${xdg.configHome}/wget/config";

            # Editor settings
            EDITOR = editor;
            VISUAL = editor;

            # Pager settings
            LESS = "-r -F";
            BAT_PAGER = lessCmd;
            DELTA_PAGER = lessCmd;
            PAGER = lessCmd;
            MANPAGER = "${editor} +Man!";

            # Color settings
            GCC_COLORS = "error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33";
            GREP_COLORS = ":mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40";

            # LS_COLORS from vivid
            LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-mocha)";
        };

        home.sessionPath = [
            "${home.homeDirectory}/.local/bin"
            "${xdg.dataHome}/cargo/bin"
            "${xdg.dataHome}/pnpm"
            "${xdg.cacheHome}/.bun/bin"
            "${xdg.dataHome}/go/bin"
        ];

        home.shellAliases = {
            # Core utils aliases
            du = "du -h";
            grep = "grep --color";
            exe = "chmod +x";
            cat = "${pkgs.bat}/bin/bat";

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
    };
}
