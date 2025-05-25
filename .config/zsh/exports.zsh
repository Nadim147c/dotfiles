CUSTOM_PATH=(
	"$HOME/.local/bin"
	"$HOME/.cargo/bin"
	"$HOME/.bun/bin"
	"$HOME/.local/share/pnpm"
	"$HOME/.spicetify"
	"$HOME/go/bin"
	"$HOME/.local/share/go/bin/"
	"/usr/local/go/bin"

	"$HOME/git/jsutils/bin"
)
export PATH="$PATH:${(j.:.)CUSTOM_PATH}"

export GOPATH="$HOME/.local/share/go"

export FZF_DEFAULT_OPTS='
--color=fg:#cdd6f4,header:#f9e2af,info:#94e2d5,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
--layout reverse
'

export PNPM_HOME="$HOME/.local/share/pnpm/"

export EDITOR=$(command -v nvim)
export VISUAL=$EDITOR
export ZELLIJ_EDITOR=${$(command -v vim):-$EDITOR}

export PAGER='less -r -F'
export LESS='-r -F'
export BAT_PAGER='less -r -F'
export DELTA_PAGER='less -r -F'

export RUSTC_WRAPPER=sccache

export GRAVEYARD="$HOME/.local/share/graveyard/"

export GCC_COLORS='error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33'
export GREP_COLORS=':mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40'

export CARAPACE_MATCH=CASE_INSENSITIVE
export LS_COLORS=$(vivid generate catppuccin-mocha)
export CHROMASHIFT_CONFIG="$HOME/git/ChromaShift/config.toml"
export CHROMASHIFT_RULES="$HOME/git/ChromaShift/rules"
