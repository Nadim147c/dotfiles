#!/bin/nu

def post_hooks [] {
    # Reload kitty, waybar, swaync, firefox, alacritty
    killall -v -SIGUSR1 kitty | complete | get stdout
    killall -v -SIGUSR2 waybar | complete | get stdout
    pywalfox --verbose update | complete | get stdout
    touch ~/.config/alacritty/alacritty.toml

    pkill swaync | complete | get stdout
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
        where $it =~ '.*\.(jpg|jpeg|png|webm)' and $it not-in $current_wallpaper |
        get (random int ..<($in | length))
}

def generate_colors [image: string] {
    print $"Generating color for ($image)"
    rong video -- $image
    post_hooks
}

def set_wallpaper [wallpaper: string] {
    print $"setting wallpaper ($wallpaper)"
    if (ps | where name == hyprpaper | is-empty) {
        hyprctl dispatch -- exec hyprpaper
    }
    hyprctl hyprpaper preload $wallpaper
    hyprctl monitors -j | from json | each { hyprctl hyprpaper wallpaper $"($in.name),($wallpaper)" }
    hyprctl hyprpaper unload all
}

def main [wallpaper?: string, --no-set-wallpaper] {
    if $wallpaper != null {
        generate_colors $wallpaper
        if not $no_set_wallpaper {set_wallpaper $wallpaper}
    } else {
        let wallpaper = (get_walpaper)
        generate_colors $wallpaper
        if not $no_set_wallpaper {set_wallpaper $wallpaper}
    }
}
