#!/bin/sh

if [ -z "$TMUX" ] && [ -z "$ZELLIJ" ]; then
    LOGO=$(find "$HOME/Pictures/fastfetch/" -type f | shuf -n1)
fi

if [ -n "$LOGO" ]; then
    echo "$LOGO"
    exit
fi

echo "$HOME/.config/fastfetch/logo"
