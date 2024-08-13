CUSTOM_PATH=(
	"$HOME/.local/bin"
	"$HOME/.cargo/bin"
	"$HOME/.local/share/pnpm"
	"$HOME/.spicetify"
	"/usr/local/go/bin"
	"$HOME/go/bin"
)
for item in ${CUSTOM_PATH[@]}; do
	export PATH="$PATH:$item"
done
[[ -f "$HOME/git/jsutils/path" ]] && source "$HOME/git/jsutils/path"

export FZF_DEFAULT_OPTS='
--color=fg:#cdd6f4,header:#a6e3a1,info:#94e2d5,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
--info=inline --layout reverse --border
'

export SANDBOXRC="$HOME/.zsh.conf/.sandboxrc"
export PNPM_HOME="$HOME/.local/share/pnpm/"

export EDITOR="nvim"
export VISUAL="nvim"

export PAGER="less -r -F"
export BAT_PAGER="less -r -F"
export DELTA_PAGER="less -r -F"

[[ $commands[sccache] ]] && export RUSTC_WRAPPER=sccache
[[ $commands[powerpill] ]] && export PACMAN_WRAPPER=powerpill
