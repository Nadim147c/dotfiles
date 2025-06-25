# LS
alias ll = ls --long --du
alias l = ls -lam
alias la = ls -a
alias fn = ^find
alias n = pnpm

alias dotsync = stow -d ~/git/dotfiles/ -t ~/ --no-folding .

# Core utils
alias du = ^du -h
alias grep = ^grep --color
alias less = ^less -r -F

# Cd
alias rd = cd - # Return to previous directory
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..


alias delta = ^delta --line-numbers --hunk-header-decoration-style none
alias ffmpeg = ^ffmpeg -hide_banner

def ff [] { clear; ^fastfetch }

# Choose a random item from a table or list
def "get random" [] {
    if $in == null { error make --unspanned { msg: "Input must be a table or list" } }
    $in | get (random int ..<($in | length))
}

# Choose a random item from a table or list
def name-uuid [...files: string] {
    for file in $files {
        let name = $file | path expand | path parse
        mv ($file | path expand) $"($name.parent)/(random uuid).($name.extension)"
    }
}

source ~/.config/nushell/modules/archlinux.nu
source ~/.config/nushell/modules/git.nu
source ~/.config/nushell/modules/zellij.nu
source ~/.config/nushell/modules/yt-dlp.nu
source ~/.config/nushell/modules/organize.nu
source ~/.config/nushell/modules/ffmpeg.nu
source ~/.config/nushell/modules/imagemagick.nu

if ("ZELLIJ" not-in $env) and ("TMUX" not-in $env) {
    fastfetch
}

def disk [...p] {
    ^df ...$p
    | ^column -t
    | from ssv
    | rename filesystem size used available percent mounted
    | upsert size { |it|$it.size | into int | $in * 1000 | into filesize}
    | upsert used { |it|$it.used | into int | $in * 1000 | into filesize}
    | upsert available { |it|$it.available | into int | $in * 1000 | into filesize}
    | sort-by size
}

$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.use_kitty_protocol = true

$env.config.history = {
    file_format: sqlite
    max_size: 10_000_000
    sync_on_enter: true
    isolation: false
}

$env.CARAPACE_LIST = (carapace --list | lines | each {split row ' ' | first})

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

let external_completer = {|spans|
    let expanded_alias = scope aliases | where name == $spans.0 | get -i 0.expansion
    let spans = if $expanded_alias != null {
        $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    if $spans.0 == "sudo" {
        do $fish_completer $spans
    } else if $spans.0 in $env.CARAPACE_LIST {
        do $carapace_completer $spans
    } else {
        do $fish_completer $spans
    }
}

$env.config.completions.external = {
    enable: true
    completer: $external_completer
}

$env.config.completions = {
    algorithm: "fuzzy"
    sort: "smart"
    case_sensitive: false
    quick: true
    partial: true
    use_ls_colors: true
}
$env.config.use_kitty_protocol = true

$env.config.hooks.command_not_found = {|cmd|
    findpkg $cmd
}

$env.config.display_errors.termination_signal = false
$env.config.footer_mode = "auto"

$env.config.color_config.shape_external_resolved = true

$env.config.color_config = {
    shape_globpattern: blue
    shape_filepath: magenta
    shape_redirection: red
    shape_string: red
    shape_flag: red
    shape_external: blue
    shape_pipe: yellow

    header: blue
    glob: blue
    float: yellow
    int: yellow
    bool: {if $in { "yellow" } else { "blue" }}
    date: green
    separator: black
    row_index: yellow
}

# $env.VIRTUAL_ENV_DISABLE_PROMPT = true
$env.config = ($env.config | upsert hooks {
    env_change: {
        PWD: [
            {
                condition: {|before, after| ("VIRTUAL_ENV" in $env) and ("activate" in (overlay list)) }
                code: "overlay hide activate --keep-env [ PWD ]"
            },
            {
                condition: {|before, after| ".venv/bin/activate.nu" | path exists }
                code: "overlay use .venv/bin/activate.nu"
            },
        ]
    }
})
