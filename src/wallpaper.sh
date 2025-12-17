WALLPAPER_DIR="$(systemd-path user-videos)/wallpapers"
STATE_FILE="$(systemd-path user-state-private)/wallpaper.state"

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
