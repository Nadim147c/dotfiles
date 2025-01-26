# LS
alias ll = ls --long --du
alias l = ls -lam
alias la = ls -a
alias fn = ^find
alias n = pnpm

alias dotsync = stow -d ~/git/dotfiles/ -t ~/ .

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

def man [...$rest: any] { ^batman ...$rest }
def ff [] { clear; ^fastfetch }

source ~/.config/nushell/modules/archlinux.nu
source ~/.config/nushell/modules/git.nu
source ~/.config/nushell/modules/zellij.nu

source ~/.cache/nushell/carapace.nu
source ~/.cache/nushell/starship.nu
source ~/.cache/nushell/zoxide.nu
source ~/.cache/nushell/atuin.nu
source ~/.cache/nushell/mise.nu

$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.use_kitty_protocol = true

$env.config.history = {
    file_format: sqlite
    max_size: 10_000_000
    sync_on_enter: true
    isolation: false
}

$env.config.completions = {
    algorithm: "fuzzy"
    sort: "smart"
    case_sensitive: true
    quick: true
    partial: true
    use_ls_colors: true
}

$env.config.hooks.command_not_found = {|cmd|
    findpkg $cmd
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    let expanded_alias = scope aliases | where name == $spans.0 | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config.completions.external =  {
    enable: true
    completer: $external_completer
}
