{
    home,
    xdg,
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "shell";
    options = delib.singleEnableOption true;

    home.ifEnabled = let
        editor = "${pkgs.neovim}/bin/nvim";
        lessCmd = "${pkgs.less}/bin/less -r -F";
    in {
        home.packages = with pkgs; [
            btop
            chafa
            cmatrix
            coreutils-full
            crop-image
            ffmpeg
            findutils
            fork
            fzf
            gallery-dl
            gum
            image-detect
            jq
            killall
            less
            nitch
            openssl
            procps
            xxHash
            xxd
            yq
        ];

        home.sessionVariables = {
            # Editor settings
            EDITOR = editor;
            VISUAL = editor;

            # Pager settings
            LESS = "-r -F";
            DELTA_PAGER = lessCmd;
            PAGER = lessCmd;

            # Color settings
            GCC_COLORS = "error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33";
            GREP_COLORS = ":mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40";
        };

        home.sessionPath = [
            "${home.home.homeDirectory}/.local/bin"
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

            x = "xargs";

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
    };
}
