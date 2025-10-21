#!/usr/bin/env bash

WALLPAPER_DIR="${XDG_VIDEOS_DIR:-$HOME/media/videos}/wallpapers"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/wallpaper.state"

# Function to run post-processing hooks
post_hooks() {
    # allow one or more commands to fails without exit
    set +e pipefail

    # Compile SCSS files for various components
    compile-scss ~/.config/swaync/style.scss
    compile-scss ~/.config/swayosd/style.scss
    compile-scss ~/.config/waybar/style.scss
    compile-scss ~/.config/wlogout/style.scss
    compile-scss ~/.config/wofi/style.scss

    dunst_level=$(dunstctl get-pause-level)
    dunstctl reload && dunstctl set-pause-level "$dunst_level"

    # Reload applications by sending signals
    pywalfox --verbose update

    pkill swaync && fork swaync
    pkill swayosd-server && fork swayosd-server

    kill -SIGUSR2 "$(pidof waybar)"
    kill -SIGUSR1 "$(pidof kitty)"

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
