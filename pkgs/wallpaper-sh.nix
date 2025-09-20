{
    compile-scss,
    coreutils,
    crudini,
    dunst,
    fd,
    fork,
    gawk,
    gnugrep,
    hyprland,
    killall,
    procps,
    socat,
    writeShellApplication,
    ...
}:
writeShellApplication {
    name = "wallpaper.sh";
    runtimeInputs = [
        compile-scss
        coreutils
        crudini
        dunst
        fd
        fork
        gawk
        gnugrep
        hyprland
        killall
        procps
        socat
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
            mkdir -p ~/Videos/Wallpapers
            fd '\.(mp4|mkv|webm|gif)$' ~/Videos/Wallpapers | shuf -n1
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
            rong video -- "$image"
            post_hooks # Run post-processing after color generation
        }

        # Function to set wallpaper with swww
        set_wallpaper() {
            echo "Setting wallpaper: $1"
            printf 'loadfile %q\n' "$1" | socat - /tmp/mpv-socket-All

            mkdir -p ~/.local/state
            echo -n "$1" > ~/.local/state/wallpaper.state
            crudini --set ~/.local/state/waypaper/state.ini State wallpaper "$1" || true
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
