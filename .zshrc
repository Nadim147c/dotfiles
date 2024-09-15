function _set_prompt() { PS1=$(printf "\e[1m\e[36m%s\e[0m\n" "$1"); }
function _zinit_check_plugin() {
    for arg in "$@"; do
        printf '%s\n' $ZINIT_REGISTERED_PLUGINS | grep -q "^$arg$" || return 1
    done
    return 0
}

_set_prompt 'Loading bootstrapping...'

# Download Zinit, if it's not there yet
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

_set_prompt 'Loading config...'

# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

local ZINIT_ANNEX=(
    zdharma-continuum/zinit-annex-bin-gem-node
    zdharma-continuum/zinit-annex-patch-dl
    zdharma-continuum/zinit-annex-linkman
)
zinit light-mode depth1 id-as for $ZINIT_ANNEX

bindkey -e

source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/bindings.zsh"
source "$HOME/.config/zsh/alias.zsh"
source "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/programs.zsh"
source "$HOME/.config/zsh/snippets.zsh"
source "$HOME/.config/zsh/plugins.zsh"
source "$HOME/.config/zsh/completion.zsh"
source "$HOME/.config/zsh/commands.zsh"
