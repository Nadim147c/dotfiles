# shellcheck disable=all

function _set_prompt() { PS1=$(printf "\e[1;36m%s\e[0m" "$1"); }
function _zinit_check_plugin() {
    for arg in "$@"; do [[ " ${ZINIT_REGISTERED_PLUGINS[@]} " =~ " $arg " ]] || return 1; done
}

# Download Zinit, if it's not there yet
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    _set_prompt "Installing zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || return 1
fi

_set_prompt 'Loading zinit...'

# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

zinit light-mode depth1 id-as for \
    @zdharma-continuum/zinit-annex-{binary-symlink,patch-dl,linkman}

_set_prompt 'Sourcing modules...'
for module in exports bindings aliases plugins programs snippets completion commands; do
    file="$HOME/.config/zsh/$module.zsh"
    compiled_file="${file}.zwc"

    if [[ ! -f $compiled_file || "$file" -nt "$compiled_file" ]]; then
        echo "Compiling: $file"
        zcompile "$file"
    fi
    source "$file"
done

unfunction _set_prompt
