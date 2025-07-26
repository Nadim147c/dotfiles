#!/usr/bin/env bash

fork() {
    hyprctl dispatch exec -- "$@"
}

# Function to run post-processing hooks
post_hooks() {
    # Compile SCSS files for various components
    compile-scss.sh ~/.config/waybar/style.scss && killall -v -SIGUSR2 waybar &
    compile-scss.sh ~/.config/swaync/style.scss && pkill swaync && fork swaync &
    compile-scss.sh ~/.config/swayosd/style.scss && pkill swayosd-server && fork swayosd-server
    compile-scss.sh ~/.config/wofi/style.scss &

    local dunst_level=$(dunstctl get-pause-level)
    dunstctl reload && dunstctl set-pause-level "$dunst_level"

    # Reload applications by sending signals
    pywalfox --verbose update &
    killall -v -SIGUSR1 kitty &

    hyprctl reload
    hyprctl keyword misc:disable_autoreload false

    sleep 1.5 # Ensure all the command finished running
}

# Function to get a random wallpaper path
get_wallpaper() {
    # Create directory if missing
    mkdir -p ~/Videos/Wallpapers/

    # Get currently loaded wallpapers (ignore errors)
    local current_wallpapers=$(hyprctl hyprpaper listloaded 2>/dev/null | awk '{$1=$1};1' || true)

    # Find candidate wallpapers (images not currently loaded)
    local candidates=()
    while IFS= read -r file; do
        # Skip if file is in current wallpapers
        if echo "$current_wallpapers" | grep -qFx "$file"; then
            continue
        fi
        candidates+=("$file")
    done < <(find ~/Pictures/Wallpapers/ -type f \( \
        -iname "*.jpg" -o \
        -iname "*.jpeg" -o \
        -iname "*.png" -o \
        -iname "*.webp" \))

    printf '%s\n' "${candidates[@]}" | shuf -n1
}

# Function to generate color scheme from image
generate_colors() {
    local image="$1"
    echo "Generating color for $image"
    rong image -- "$image"
    post_hooks # Run post-processing after color generation
}

# Function to set wallpaper with swww
set_wallpaper() {
    local wallpaper="$1"
    echo "Setting wallpaper $wallpaper"

    # Start swww daemon if not running
    if ! pgrep swww-daemon >/dev/null; then
        fork swww-daemon
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
    hyprctl keyword misc:disable_autoreload true

    if [ -n "$wallpaper" ]; then
        set_wallpaper "$wallpaper"
        generate_colors "$wallpaper"
    else
        wallpaper=$(get_wallpaper)
        if [ -n "$wallpaper" ]; then
            set_wallpaper "$wallpaper"
            generate_colors "$wallpaper"
        else
            echo "Error: No suitable wallpaper found" >&2
            exit 1
        fi
    fi
}

# Execute main function with arguments
main "$@"
