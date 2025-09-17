{
    compile-scss,
    coreutils,
    dunst,
    fd,
    fork,
    gawk,
    gnugrep,
    hyprland,
    killall,
    procps,
    swww,
    writeShellApplication,
    ...
}:
writeShellApplication {
    name = "wallpaper.sh";
    runtimeInputs = [
        compile-scss
        coreutils
        dunst
        fd
        fork
        gawk
        gnugrep
        hyprland
        killall
        procps
        swww
    ];

    text = ''
        # Function to run post-processing hooks
        post_hooks() {
            # allow one or more commands to fails without exit
            set +e pipefail

            # Compile SCSS files for various components
            compile-scss ~/.config/waybar/style.scss
            compile-scss ~/.config/swaync/style.scss
            compile-scss ~/.config/swayosd/style.scss
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
        }

        # Function to get a random wallpaper path
        get_wallpaper() {
            # Create directory if missing
            mkdir -p ~/Pictures/Wallpapers/

            # Get currently loaded wallpapers (ignore errors)
            current_wallpapers=$(hyprctl hyprpaper listloaded 2>/dev/null | awk '{$1=$1};1' || true)

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

            printf '%s\n' "''${candidates[@]}" | shuf -n1
        }

        rong() {
            if [ -f "$HOME/.local/bin/rong" ]; then
                "$HOME/.local/bin/rong" "$@"
            else
                command rong "$@"
            fi
        }

        # Function to generate color scheme from image
        generate_colors() {
            image="$1"
            echo "Generating color scheme for $image"
            rong image -- "$image"
            post_hooks # Run post-processing after color generation
        }

        # Function to set wallpaper with swww
        set_wallpaper() {
            wallpaper="$1"
            echo "Setting wallpaper: $wallpaper"

            # Start swww daemon if not running
            if ! pgrep swww-daemon >/dev/null; then
                fork swww-daemon
            fi

            # Get cursor position in required format
            cursor_pos=$(hyprctl cursorpos | tr -d ' ')

            # Random transition types
            transitions=("grow" "outer")
            rand_transition=''${transitions[$RANDOM % ''${#transitions[@]}]}

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

        main() {
            if [ $# -ge 1 ]; then
                wallpaper="$1"
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
    '';
}
