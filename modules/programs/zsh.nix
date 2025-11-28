{
    delib,
    lib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.zsh";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.zsh = {
        enable = true;
        enableCompletion = false;
        history.path = "${xdg.dataHome}/zsh/history";
        history.ignoreSpace = true;
        completionInit = "";
        initContent = lib.mkOrder 500 # bash

        ''
            source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
            source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
            source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

            zstyle ':completion:*:git-checkout:*' sort false
            zstyle ':completion:*:descriptions' format '[%d]'
            zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
            zstyle ':completion:*' menu no
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
            zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --border=none
            zstyle ':fzf-tab:*' use-fzf-default-opts yes
            zstyle ':fzf-tab:*' switch-group '<' '>'
            zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
            zstyle ':fzf-tab:*' popup-min-size 80 12
        '';
    };
}
