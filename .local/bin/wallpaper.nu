#!/bin/nu

def post_hooks [] {
    install -vDm644 ~/.cache/matugen/gtk.css ~/.config/gtk-3.0/gtk.css
    install -vDm644 ~/.cache/matugen/gtk.css ~/.config/gtk-4.0/gtk.css
    install -vDm644 ~/.cache/matugen/colors.scss ~/.config/eww/styles/colors.scss
    install -vDm644 ~/.cache/matugen/spicetify.ini ~/.config/spicetify/Themes/Sleek/color.ini
    install -vDm644 ~/.cache/matugen/ghostty ~/.config/ghostty/colors
    install -vDm644 ~/.cache/matugen/hyprpaper.conf ~/.config/hypr/hyprpaper.conf

    # Reload kitty, waybar, swaync, firefox, alacritty
    killall -v -SIGUSR1 kitty
    killall -v -SIGUSR2 waybar
    pywalfox --verbose update
    touch ~/.config/alacritty/alacritty.toml

    try {
        pkill swaync
        hyprctl dispatch exec -- swaync
    }

    # Reload spotify (spicetify)
    if (ps --long | where command =~ "spicetify watch -s" | is-empty) {
        hyprctl dispatch -- exec spicetify watch -s
    }

    hyprctl reload
}

def get_walpaper []: nothing -> string {
    let current_wallpaper = (hyprctl hyprpaper listloaded | lines | str trim)

    mkdir ~/Pictures/Wallpapers/

    ^find ~/Pictures/Wallpapers/ -type f | lines |
        where $it =~ '.*\.(jpg|jpeg|png|webm)' and $it not-in $current_wallpaper |
        to text | shuf -n1
}

def generate_colors [image?: string] {
    if $image != null {
        print $"Generating color from ($image)"
        matugen image $image --verbose
        try { rong image -- $image }
    } else {
        matugen color hex "#00ff00" --verbose
    }
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
        if not $no_set_wallpaper {set_wallpaper $wallpaper}
        generate_colors $wallpaper
    } else {
        let wallpaper = (get_walpaper)
        if not $no_set_wallpaper {set_wallpaper $wallpaper}
        generate_colors $wallpaper
    }
}
