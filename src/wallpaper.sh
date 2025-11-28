#!/usr/bin/env bash

WALLPAPER_DIR="$(systemd-path user-videos)/wallpapers"
STATE_FILE="$(systemd-path user-state-private)/wallpaper.state"

# Function to run post-processing hooks
post_hooks() {
    # allow one or more commands to fails without exit
    set +e pipefail

    compile-scss ~/.config/wofi/style.scss

    dunst_level=$(dunstctl get-pause-level)
    dunstctl reload && dunstctl set-pause-level "$dunst_level"

    # Reload applications by sending signals
    pywalfox --verbose update

    pkill swaync && fork swaync
    pkill swayosd-server && fork swayosd-server

    pidof kitty | xargs kill -SIGUSR1

    tmux source-file ~/.config/tmux/tmux.conf

    hyprctl reload

    eww reload
    timeout 2s spicetify watch -s
    exit 0
}

# Function to get a random wallpaper path
get_wallpaper() {
    mkdir -p "$WALLPAPER_DIR"
    fd '\.(mp4|mkv|webm|gif)$' "$WALLPAPER_DIR" | shuf -n1
}

rong() {
    if [ -f "$HOME/.local/bin/rong" ]; then
        "$HOME/.local/bin/rong" "$@"
    else
        env rong "$@"
    fi
}

# Function to generate color scheme from image
generate_colors() {
    image="$1"
    gum format "# Generating color scheme for $image"
    rong video -- "$image"
    post_hooks # Run post-processing after color generation
}

# Function to set wallpaper with swww
set_wallpaper() {
    gum format "# Setting wallpaper: $1"
    touch "$1"
    mkdir -p "$(dirname "$STATE_FILE")"
    echo -n "$1" >"$STATE_FILE"
}

main() {
    if [ $# -ge 1 ]; then
        wallpaper="$1"
    else
        wallpaper=$(get_wallpaper)
    fi

    if [ -z "$wallpaper" ]; then
        echo "Error: No suitable wallpaper found" >&2
        exit 1
    fi

    set_wallpaper "$wallpaper"
    generate_colors "$wallpaper"
}

# Execute main function with arguments
main "$@"
