#!/bin/sh

_swaync_log() {
    "$@" 2>&1 | tee -a ~/.local/share/logs/swaync.log
}

_swaync_log swaync &

while true; do
    inotifywait -e create,modify ~/.config/swaync/*
    swaync-client --reload-config
    swaync-client --reload-css
done
