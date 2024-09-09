# Download Zinit, if it's not there yet
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

bindkey -e

source "$HOME/.zshrc.d/exports.zsh"
source "$HOME/.zshrc.d/bindings.zsh"
source "$HOME/.zshrc.d/alias.zsh"
source "$HOME/.zshrc.d/plugins.zsh"
source "$HOME/.zshrc.d/completion.zsh"
source "$HOME/.zshrc.d/commands.zsh"
