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

def man [...$rest: any] { ^batman ...$rest }
def ff [] { clear; ^fastfetch }


# Choose a random item from a table or list
def "get random" [] { $in | get (random int ..<($in | length)) }

source ~/.config/nushell/modules/archlinux.nu
source ~/.config/nushell/modules/git.nu
source ~/.config/nushell/modules/zellij.nu
source ~/.config/nushell/modules/yt-dlp.nu
source ~/.config/nushell/modules/organize.nu

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
    algorithm: "prefix"
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
