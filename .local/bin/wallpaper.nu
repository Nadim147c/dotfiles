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
    mut current_wallpaper  = ""
    try {
        $current_wallpaper = open --raw ~/.cache/wallpaper
    }

    mkdir ~/Videos/Wallpapers/

    let wallpaper = (
        ^find ~/Videos/Wallpapers/ -type f | lines
        | where $it =~ '.*\.(mp4|mkv|webm)' and $it != $current_wallpaper
        | get (random int ..<($in | length))
    )

    $wallpaper
}

def generate_colors [image: string] {
    print $"Generating color for ($image)"
    rong video -- $image
    post_hooks
}

def set_wallpaper [wallpaper: string] {
    print $"setting wallpaper ($wallpaper)"
    ^echo $"loadfile \"($wallpaper)\"" | socat - /tmp/mpvpaper.sock
}

def main [wallpaper?: string, --no-set-wallpaper] {
    if $wallpaper != null {
        generate_colors $wallpaper
        if not $no_set_wallpaper {set_wallpaper $wallpaper}
        echo $wallpaper | path expand | to text | save -f ~/.cache/wallpaper
    } else {
        let wallpaper = (get_walpaper)
        generate_colors $wallpaper
        if not $no_set_wallpaper {set_wallpaper $wallpaper}
        echo $wallpaper | path expand | to text | save -f ~/.cache/wallpaper
    }
}
