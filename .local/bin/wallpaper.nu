#!/usr/bin/env nu

def complie_scss [input: string] {
    let path = $input | path expand --no-symlink
    let parsed = $path | path parse
    let output = $"($parsed.parent)/($parsed.stem).css"

    rm -vf $output
    mkdir $parsed.parent

    print $"Compiling ($path) | Output ($output)"
    scss --no-cache $path | save -f $output
}

def post_hooks [] {
    complie_scss ~/.config/waybar/style.scss
    complie_scss ~/.config/swaync/style.scss

    # Reload kitty, waybar, swaync, firefox, alacritty
    killall -v -SIGUSR1 kitty | complete
    killall -v -SIGUSR2 waybar | complete
    pywalfox --verbose update | complete
    touch ~/.config/alacritty/alacritty.toml

    pkill swaync | complete
    hyprctl dispatch exec -- swaync

    # Reload spotify (spicetify)
    if (ps --long | where command =~ "spicetify watch -s" | is-empty) {
        hyprctl dispatch -- exec spicetify watch -s
    }

    hyprctl reload
}

def get_walpaper []: nothing -> string {
    let current_wallpaper = (hyprctl hyprpaper listloaded | lines | str trim)
    mkdir ~/Videos/Wallpapers/

    ^find ~/Pictures/Wallpapers/ -type f | lines |
        where $it =~ '.*\.(jpg|jpeg|png|webp)' and $it not-in $current_wallpaper |
        get (random int ..<($in | length))
}

def generate_colors [image: string] {
    print $"Generating color for ($image)"
    rong video -- $image
    post_hooks
}

def set_wallpaper [wallpaper: string] {
    print $"setting wallpaper ($wallpaper)"
    if (ps | where name == swww-daemon | is-empty) {
        hyprctl dispatch exec -- swww-daemon
    }

    let cursor = hyprctl cursorpos | str replace ", " ","

    (hyprctl dispatch exec --
        swww img
        --transition-type ([grow outer] | get (random int ..<($in | length)))
        --transition-duration 2
        --transition-pos $cursor
        --transition-bezier ".09,.91,.52,.93"
        --transition-fps 60
        --invert-y
        $wallpaper)
}

def main [wallpaper?: string] {
    if $wallpaper != null {
        set_wallpaper $wallpaper
        generate_colors $wallpaper
    } else {
        let wallpaper = (get_walpaper)
        set_wallpaper $wallpaper
        generate_colors $wallpaper
    }
}
