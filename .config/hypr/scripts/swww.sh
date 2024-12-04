#!/bin/sh

_log() {
    echo "$@" | logger -t 'swww-script'
}
_logger() {
    "$@" 2>&1 | logger -t 'swww-script'
}

_get_wallpaper() {
    current_wallpaper=$(swww query | grep -o '/.\+$' || echo "<IGNORE_ME>")

    find -L ~/Pictures/Wallpapers/ -type f |
        grep -P '\.(jpg|jpeg|png|webm)$' |
        grep -Fv "$current_wallpaper" |
        shuf -n1
}

_gen_colors() {
    _logger echo "Generating color from '$1'"
    _logger matugen image "$1" --show-colors
}

_set_wallpaper() {
    cursor_pos=$(hyprctl cursorpos | sed 's/ //')

    if ! echo "$cursor_pos" | grep -Pq "^[0-9]+,[0-9]+$"; then
        cursor_pos="0,0"
    fi

    _log "Setting wallpaper ($cursor_pos) '$1'"

    swww img \
        --transition-type=grow \
        --transition-fps=30 \
        --invert-y --transition-pos="$cursor_pos" \
        --transition-bezier='.43,1.19,1,.4' \
        --transition-duration='0.6' \
        "$1"
}

wallpaper=$(_get_wallpaper)

_log "Selected wallpaper is '$wallpaper'"

if [ "$1" = "--startup" ]; then
    _log "Starting swww-daemon"
    _logger swww-daemon
    exit
fi

_set_wallpaper "$wallpaper" &
_gen_colors "$wallpaper"
