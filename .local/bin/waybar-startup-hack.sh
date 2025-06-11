#!/bin/bash

# this script is hack for waybar for some reason not starting at startup this script will
# re-run waybar until waybar is active and this runs for 30seconds

# Duration to run (in seconds)
DURATION=30
# Interval between checks (in seconds)
INTERVAL=1

START_TIME=$(date +%s)

while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))

    if [ "$ELAPSED" -ge "$DURATION" ]; then
        break
    fi

    if ! pgrep -x waybar > /dev/null; then
        echo "Waybar not running. Starting waybar..."
        hyprctl dispatch exec waybar
    fi

    sleep "$INTERVAL"
done

