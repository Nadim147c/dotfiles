$env.TRANSIENT_PROMPT_INDICATOR = ""
$env.TRANSIENT_PROMPT_COMMAND = false

$env.XDG_CONFIG_HOME = $env.HOME | path join ".config"
$env.XDG_CACHE_HOME = $env.HOME | path join ".cache"
$env.XDG_DATA_HOME = $env.HOME | path join ".local" "share"
$env.XDG_STATE_HOME = $env.HOME | path join ".local" "state"

$env.LS_COLORS = (vivid generate catppuccin-mocha | str trim)

$env.Path = [
    "/usr/local/go/bin"
    $"($env.HOME)/.local/bin"
    $"($env.HOME)/.cargo/bin"
    $"($env.HOME)/.bun/bin"
    $"($env.HOME)/.local/share/pnpm"
    $"($env.HOME)/.spicetify"
    $"($env.HOME)/go/bin"
    $"($env.HOME)/.local/share/go/bin/"
] ++ $env.Path

$env.PATH = ($env.PATH | str replace --regex '/$' '' | uniq)

$env.GOPATH = $"($env.HOME)/.local/share/go"
$env.PNPM_HOME = $"($env.HOME)/.local/share/pnpm/"

$env.SKIM_DEFAULT_OPTIONS = $"($env | get SKIM_DEFAULT_OPTIONS --ignore-errors | default "")
--layout reverse --border
--color=fg:#cdd6f4,bg:-1,gutter:-1,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086
"
$env.FZF_DEFAULT_OPTS = "
--color=fg:#cdd6f4,header:#f9e2af,info:#94e2d5,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#94e2d5,hl+:#a6e3a1
--layout reverse --border
"

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
