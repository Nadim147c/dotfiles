#!/bin/sh

_log() {
    echo "$@" | logger -t 'waybar-script'
}
_logger() {
    "$@" 2>&1 | logger -t 'waybar-script'
}

_logger swaync &

_log "Running swaync config daemon..."
while true; do
    inotifywait -e create,modify ~/.config/swaync/*
    _log "Reloading swaync config"
    _logger swaync-client --reload-config
    _logger swaync-client --reload-css
done
