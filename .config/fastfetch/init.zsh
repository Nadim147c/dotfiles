if [[ -z "$ZELLIJ" && -z "$TMUX" ]]; then
    fastfetch --logo-type kitty --logo "$(printf '%s\n' "$HOME/.config/fastfetch/logo/"* | shuf -n1)"
fi

alias fastfetch=$'fastfetch --logo-type kitty --logo "$(printf \'%s\n\' "$HOME/.config/fastfetch/logo/"* | shuf -n1)"'
