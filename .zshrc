# Download Zinit, if it's not there yet
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

source "$HOME/.zsh.conf/exports.zsh"
source "$HOME/.zsh.conf/bindings.zsh"
source "$HOME/.zsh.conf/alias.zsh"
source "$HOME/.zsh.conf/plugins.zsh"
source "$HOME/.zsh.conf/completion.zsh"
source "$HOME/.zsh.conf/commansds.zsh"
