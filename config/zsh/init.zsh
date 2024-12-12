# shellcheck disable=all
if [[ -z "$SHELL_START_TIME" ]]; then
    export SHELL_START_TIME=$(date +%s);
fi

# █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
# █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█

function set_prompt() { PS1=$(printf "\e[1;36m%s\e[0m" "$1"); }
function _zinit_check_plugin() {
    local current_time=$(date +%s)
    local elapsed_time=$((current_time - SHELL_START_TIME))
    if ((elapsed_time >= 120)); then return 0; fi

    for arg in "$@"; do
        [[ " ${ZINIT_REGISTERED_PLUGINS[@]} " =~ " $arg " ]] || return 1
    done
}

# █ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░   ▀█ █ █▄░█ █ ▀█▀
# █ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄   █▄ █ █░▀█ █ ░█░

export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    set_prompt "Installing zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || return 1
fi

set_prompt 'Loading zinit...'
# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"


# █░░ █▀█ ▄▀█ █▀▄   █▀▄▀█ █▀█ █▀▄ █░█ █░░ █▀▀ █▀
# █▄▄ █▄█ █▀█ █▄▀   █░▀░█ █▄█ █▄▀ █▄█ █▄▄ ██▄ ▄█

set_prompt 'Loading modules...'
for module in bindings aliases plugins snippets completion zellij; do
    source "$HOME/.config/zsh/$module.zsh"
done
unfunction set_prompt

export LS_COLORS="$(vivid generate catppuccin-mocha)"
