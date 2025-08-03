# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# Application-specific config paths
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship.toml"
set -gx WGETRC "$XDG_CONFIG_HOME/wget/config"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# Language/dependency paths
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"

# Cache paths
set -gx STARSHIP_CACHE "$XDG_CACHE_HOME/starship"
set -gx GOMODCACHE "$XDG_CACHE_HOME/go/mod"

# PATH configuration
set -gx PATH \
    "/usr/local/go/bin" \
    "$HOME/.local/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/share/pnpm" \
    "$HOME/.spicetify" \
    "$HOME/.nix-profile/bin" \
    "$GOPATH/bin" \
    "$XDG_CACHE_HOME/.bun/bin" \
    $PATH

# Clean up PATH (remove trailing slashes and duplicates)
set -gx PATH (string replace -r '/$' '' $PATH | awk -v RS=: '!a[$0]++' | paste -sd: -)

# Rust configuration
set -gx RUSTC_WRAPPER "sccache"

if status is-interactive
    set -U fish_greeting
    set fish_color_command blue --bold
    set fish_color_redirection yellow --bold
    set fish_color_option red
    set fish_pager_color_prefix green --bold
    set fish_pager_color_completion blue --bold
    set fish_pager_color_description white --bold

    # Editor settings
    set -gx EDITOR "nvim"
    set -gx VISUAL "nvim"

    # Pager settings
    set -gx PAGER "less -r -F"
    set -gx LESS "-r -F"
    set -gx BAT_PAGER "less -r -F"
    set -gx DELTA_PAGER "less -r -F"

    # Color settings
    set -gx GCC_COLORS "error=1;31:warning=1;33:note=1;47;107:caret=1;47;107:locus=40;1;35:quote=1;33"
    set -gx GREP_COLORS ":mt=1;36:ms=41;1;30:mc=1;41:sl=:cx=:fn=1;35;40:ln=32:bn=32:se=1;36;40"

    # ChromaShift configuration
    set -gx CHROMASHIFT_CONFIG "$HOME/git/ChromaShift/config.toml"
    set -gx CHROMASHIFT_RULES "$HOME/git/ChromaShift/rules"

    # Aliases
    alias zk='zellij kill-all-sessions -y'

    # Core utils aliases
    alias du="du -h"
    alias grep="grep --color"
    alias less="less -r -F"
    alias exe="chmod +x"
    alias cat="bat"

    # Cd aliases
    alias rd="cd -" # Return to previous directory
    alias ..="cd .."
    alias ...="cd ../.."
    alias ....="cd ../../.."
    alias .....="cd ../../../.."

    # Other aliases
    alias delta="delta --line-numbers --hunk-header-decoration-style none"
    alias ffmpeg="ffmpeg -hide_banner"

    alias gaa="git add -A"

    # Functions
    function field -a n
        awk "{ print \$$n }"
    end
end
