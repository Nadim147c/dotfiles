#!/bin/sh

_log() {
    echo "$@" | logger -t 'waybar-script'
}
_logger() {
    "$@" 2>&1 | logger -t 'waybar-script'
}

trap "killall waybar" EXIT

if ! command -v inotifywait >/dev/null 2>&1; then
    _logger waybar
    exit
fi

_log "Running waybar config daemon..."
while true; do
    _log "Reloading waybar"
    waybar &
    inotifywait -e create,modify ~/.config/waybar/config.jsonc ~/.config/waybar/style.css
    killall waybar
done
