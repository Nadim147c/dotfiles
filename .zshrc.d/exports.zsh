CUSTOM_PATH=(
	"$HOME/.local/bin"
	"$HOME/.cargo/bin"
	"$HOME/.bun/bin"
	"$HOME/.local/share/pnpm"
	"$HOME/.spicetify"
	"$HOME/go/bin"
	"/usr/local/go/bin"

	"$HOME/git/jsutils/bin"
)
export PATH="$PATH:${(j.:.)CUSTOM_PATH}"

export FZF_DEFAULT_OPTS='
--color=fg:#cdd6f4,header:#a6e3a1,info:#94e2d5,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
--info=inline --layout reverse --border
'

export PNPM_HOME="$HOME/.local/share/pnpm/"

export EDITOR="$(command -v nvim)"
export VISUAL="$EDITOR"
export ZELLIJ_EDITOR="${$(command -v vim):-$EDITOR}"

export PAGER="less -r -F"
export BAT_PAGER="less -r -F"
export DELTA_PAGER="less -r -F"

export RUSTC_WRAPPER=sccache