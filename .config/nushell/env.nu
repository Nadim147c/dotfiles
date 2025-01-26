$env.TRANSIENT_PROMPT_INDICATOR = $"(ansi red)=>> (ansi reset)"
$env.TRANSIENT_PROMPT_COMMAND =  ""

$env.LS_COLORS = (vivid generate catppuccin-mocha | str trim)

let custom_path = [
    "/usr/local/go/bin"
    $"($env.HOME)/.local/bin"
    $"($env.HOME)/.cargo/bin"
    $"($env.HOME)/.bun/bin"
    $"($env.HOME)/.local/share/pnpm"
    $"($env.HOME)/.spicetify"
    $"($env.HOME)/go/bin"
    $"($env.HOME)/.local/share/go/bin/"
    $"($env.HOME)/git/jsutils/bin"
]
$env.Path = ($env.Path | append $custom_path)

$env.GOPATH = $"($env.HOME)/.local/share/go"
$env.PNPM_HOME = $"($env.HOME)/.local/share/pnpm/"

$env.FZF_DEFAULT_OPTS = (echo `
--color=fg:#cdd6f4,header:#f9e2af,info:#94e2d5,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
--layout reverse --border
`)

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.PAGER = "less -r -F"
$env.LESS = "-r -F"
$env.BAT_PAGER = "less -r -F"
$env.DELTA_PAGER = "less -r -F"

$env.RUSTC_WRAPPER = "sccache"

$env.GCC_COLORS = "error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33"
$env.GREP_COLORS = ":mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40"

$env.CHROMASHIFT_CONFIG = $"($env.HOME)/git/ChromaShift/config.toml"
$env.CHROMASHIFT_RULES = $"($env.HOME)/git/ChromaShift/rules"
