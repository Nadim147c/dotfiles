#!/bin/sh

if ! command -v inotifywait >/dev/null 2>&1; then
    waybar &
    exit
fi

echo "Running waybar config daemon..."
while true; do
    waybar &
    inotifywait -e create,modify ~/.config/waybar/config.jsonc ~/.config/waybar/style.css
    killall -x waybar
done
