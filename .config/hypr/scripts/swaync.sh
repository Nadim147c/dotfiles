#!/bin/sh

if ! command -v inotifywait >/dev/null 2>&1; then
    swaync
else
    swaync &
fi

echo "Running swaync config daemon..."
while true; do
    inotifywait -e create,modify ~/.config/swaync/*
    echo "Reloading swaync config"
    swaync-client --reload-config
    swaync-client --reload-css
done
