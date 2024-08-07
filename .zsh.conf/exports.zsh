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
--info inline-right --layout reverse --border
'
command -v sccache &>/dev/null && export RUSTC_WRAPPER=sccache

export PNPM_HOME="$HOME/.local/share/pnpm/"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export EDITOR="nvim"
export VISUAL="nvim"

export PAGER="less -r -F"
export BAT_PAGER="less -r -F"
export DELTA_PAGER="less -r -F"
