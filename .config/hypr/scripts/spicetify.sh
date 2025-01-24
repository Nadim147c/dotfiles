#!/bin/sh

if ! pgrep -f "spicetify watch -s" >/dev/null; then
    hyprctl dispatch -- exec spicetify watch -s
fi
