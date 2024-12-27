#!/bin/sh

if pgrep -x spotify >/dev/null; then
    if ! pgrep -f "spicetify watch -s" >/dev/null; then
        hyprctl dispatch -- exec spicetify watch -s
    fi
fi
