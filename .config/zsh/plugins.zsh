# Pager for Nadim147c/zsh-help
export HELP_PAGER="$PAGER"
# Pacman wrapper for Nadim147c/zsh-archlinux
[[ $commands[powerpill] ]] && export PACMAN_WRAPPER=powerpill

zstyle ':zle:smart-kill-word' precise always
zstyle ':zle:smart-kill-word' keep-slash on

local PLUGINS=(
    # Install Syntax Highlighting
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
    zdharma-continuum/fast-syntax-highlighting

    # Install Autosuggestions
    zsh-users/zsh-autosuggestions

    # Install Autosuggestions
    MichaelAquilina/zsh-autoswitch-virtualenv
    djui/alias-tips

    # Install My forks of zsh plugins
    Nadim147c/zsh-archlinux
    Nadim147c/zsh-help

    # Install fzf-tab (use fzf for tab completions)
    Aloxaf/fzf-tab

    # Load command_not_found_handler
    # Load better command_not_found_handler for Arch Linux
    atload='[[ $commands[findpkg] ]] && command_not_found_handler() { findpkg "$1"; }'
    Freed-Wu/zsh-command-not-found

    atload=$'
    bindkey \'^h\'       smart-backward-kill-word
    bindkey \'\\e[3;5~\' smart-forward-kill-word'
    seletskiy/zsh-smart-kill-word

    # Git plugins                (skip installing aliased command)
    atpull='%atclone' atclone="make install PREFIX=$ZPFX <<(yes n) >/dev/null"
    cp="etc/*.zsh -> _git_extras"
    tj/git-extras
)

zinit light-mode depth1 id-as atpull"%atclone" wait for $PLUGINS
