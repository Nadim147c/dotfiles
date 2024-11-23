#!/bin/sh

trap "killall waybar" EXIT

if ! command -v inotifywait >/dev/null 2>&1; then
    waybar 2>&1 | tee -a ~/.local/share/logs/waybar.log
    exit
fi

echo "Running waybar config daemon..."

while true; do
    waybar 2>&1 | tee -a ~/.local/share/logs/waybar.log &
    inotifywait -e create,modify ~/.config/waybar/*
    killall waybar
done
