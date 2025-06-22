#!/bin/sh

if pgrep -x hyprlock >/dev/null; then
    echo "Hyprlock is already running..."
    exit
fi

# Path to video
VIDEO_PATH=$(cat ~/.cache/wallpaper)

# Run mpvpaper in the background
mpvpaper -l overlay -vs -o "loop panscan=1.0 background-color='#222222' mute=yes config=no" "*" "$VIDEO_PATH" &
sleep 1
MPV_PID=$!

hyprlock

# Kill the mpvpaper process
kill "$MPV_PID"

