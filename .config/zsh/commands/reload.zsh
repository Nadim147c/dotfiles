export ZSH_MODULES_DIR="$(dirname "$(dirname "$0")")"

function reload() {
    if [[ -n "$1" ]]; then
        echo "Reloading $1"
        source "$ZSH_MODULES_DIR/$1.zsh"
    else
        echo "Doing complete reload"
        source "$HOME/.zshrc"
    fi
}
