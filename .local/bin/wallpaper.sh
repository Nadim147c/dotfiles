#!/usr/bin/env bash

# Function to run post-processing hooks
post_hooks() {
    # Compile SCSS files for various components
    compile-scss.sh ~/.config/waybar/style.scss
    compile-scss.sh ~/.config/swaync/style.scss
    compile-scss.sh ~/.config/wofi/style.scss

    # Reload applications by sending signals
    killall -v -SIGUSR1 kitty
    killall -v -SIGUSR2 waybar
    pywalfox --verbose update
    touch ~/.config/alacritty/alacritty.toml # Triggers Alacritty reload

    # Restart swaync
    pkill swaync
    hyprctl dispatch exec -- swaync

    # Start spicetify watcher if not running
    if ! pgrep -f "spicetify watch -s" >/dev/null; then
        hyprctl dispatch -- exec spicetify watch -s
    fi

    hyprctl reload
}

# Function to get a random wallpaper path
get_wallpaper() {
    # Create directory if missing
    mkdir -p ~/Videos/Wallpapers/

    # Get currently loaded wallpapers
    # current_wallpapers=($(hyprctl hyprpaper listloaded | awk '{$1=$1};1'))

    # Find candidate wallpapers (images not currently loaded)
    mapfile -t candidates < <(
        find ~/Pictures/Wallpapers/ -type f \( \
            -iname "*.jpg" -o \
            -iname "*.jpeg" -o \
            -iname "*.png" -o \
            -iname "*.webp" \)
        # grep -vF "${current_wallpapers[@]}"
    )

    # Select random wallpaper
    if [ ${#candidates[@]} -gt 0 ]; then
        echo "${candidates[RANDOM % ${#candidates[@]}]}"
    else
        echo "" # Return empty if no candidates
    fi
}

# Function to generate color scheme from image
generate_colors() {
    local image="$1"
    echo "Generating color for $image"
    rong video -- "$image"
    post_hooks # Run post-processing after color generation
}

# Function to set wallpaper with swww
set_wallpaper() {
    local wallpaper="$1"
    echo "setting wallpaper $wallpaper"

    # Start swww daemon if not running
    if ! pgrep swww-daemon >/dev/null; then
        hyprctl dispatch exec -- swww-daemon
    fi

    # Get cursor position in required format
    local cursor_pos=$(hyprctl cursorpos | tr -d ' ')

    # Random transition types
    local transitions=("grow" "outer")
    local rand_transition=${transitions[$RANDOM % ${#transitions[@]}]}

    # Apply wallpaper with swww
    swww img \
        --transition-type "$rand_transition" \
        --transition-duration 2 \
        --transition-pos "$cursor_pos" \
        --transition-bezier ".09,.91,.52,.93" \
        --transition-fps 60 \
        --invert-y \
        "$wallpaper"
}

# Main function
main() {
    local wallpaper="$1"

    if [ -n "$wallpaper" ]; then
        set_wallpaper "$wallpaper" &
        generate_colors "$wallpaper"
    else
        wallpaper=$(get_wallpaper)
        if [ -n "$wallpaper" ]; then
            set_wallpaper "$wallpaper" &
            generate_colors "$wallpaper"
        else
            echo "Error: No suitable wallpaper found" >&2
            exit 1
        fi
    fi
}

# Execute main function with arguments
main "$@"
