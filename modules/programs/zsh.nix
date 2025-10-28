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

    home.ifEnabled.home.packages = with pkgs; [nix-zsh-completions];
    home.ifEnabled.programs.zsh = {
        enable = true;
        enableCompletion = true;
        history.path = "${xdg.dataHome}/zsh/history";
        history.ignoreSpace = true;
        completionInit = "";
        initContent = let
            plugins = with pkgs; [
                "${zsh-fzf-tab}/share/fzf-tab"
                "${zsh-fast-syntax-highlighting}/share/zsh/site-functions"
                "${zsh-autosuggestions}/share/zsh-autosuggestions"
            ];
            joinedPlugins = lib.concatStringsSep " " plugins;
        in
            lib.mkOrder 500 # bash

            ''
                source ${pkgs.zinit}/share/zinit/zinit.zsh
                zinit light-mode lucid wait for ${joinedPlugins}

                zstyle ':completion:*:git-checkout:*' sort false
                zstyle ':completion:*:descriptions' format '[%d]'
                zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
                zstyle ':completion:*' menu no
                zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
                zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --border=none
                zstyle ':fzf-tab:*' use-fzf-default-opts yes
                zstyle ':fzf-tab:*' switch-group '<' '>'
                zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
            '';
    };
}
