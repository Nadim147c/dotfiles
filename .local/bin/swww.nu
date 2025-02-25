#!/bin/nu

def post_hooks [] {
    install -vDm644 ~/.cache/matugen/gtk.css ~/.config/gtk-3.0/gtk.css
    install -vDm644 ~/.cache/matugen/gtk.css ~/.config/gtk-4.0/gtk.css
    install -vDm644 ~/.cache/matugen/discord.css ~/.config/vesktop/settings/quickCss.css
    install -vDm644 ~/.cache/matugen/colors.scss ~/.config/eww/styles/colors.scss
    install -vDm644 ~/.cache/matugen/spicetify.ini ~/.config/spicetify/Themes/Sleek/color.ini

    # Reload hyprland, kitty, waybar, swaync, firefox
    hyprctl reload
    killall -SIGUSR1 kitty
    killall -SIGUSR2 waybar
    swaync-client --reload-css
    pywalfox update

    # # Reload spotify (spicetify)
    if (ps --long | where command =~ "spicetify watch -s" | is-empty) {
        hyprctl dispatch -- exec spicetify watch -s
    }

    # Reload Goofcord discord mod
    # Not consistance
    # let goofcord = ("~/.config/goofcord/GoofCord/settings.json" | path expand)
    # if ($goofcord | path exists) {
    #     let discordCss = (open ~/.cache/matugen/discord.css | to text)
    #     open $goofcord |
    #         upsert quickcss $discordCss |
    #         upsert quickcss_time { date now } |
    #         save -f $goofcord
    # }
    # Reload goofcord with python script
    python ~/.local/bin/goofcord.py
}

def get_walpaper []: nothing -> string {
    let current_wallpaper = (swww query | grep -o '/.\+$' | lines | str trim)

    mkdir ~/Pictures/Wallpapers/

    ls ~/Pictures/Wallpapers/* |
        where type == file and name =~ '.*\.(jpg|jpeg|png|webm)' and name not-in $current_wallpaper |
        get name | to text | shuf -n1
}

def generate_colors [image?: string] {
    if $image != null {
        print $"Generating color from ($image)"
        matugen image $image --verbose
    } else {
        matugen color hex "#00ff00" --verbose
    }
    post_hooks
}

def set_wallpaper [wallpaper: string] {
    mut cursor = {x:0,y:0}

    try {
        $cursor = (hyprctl cursorpos -j | from json)
    }

    print $"Setting wallpaper \(($cursor.x),($cursor.y)\) '($wallpaper)'"

    let animation = [grow outer] | get (random int 0..1)
    let swww_flags = [
        --invert-y
        --transition-fps=60
        --transition-step=60
        --transition-duration=0.6
        "--transition-bezier=.43,1.19,1,.4"
        $"--transition-type=($animation)"
        $"--transition-pos=($cursor.x),($cursor.y)"
    ]

    swww img ...$swww_flags $wallpaper
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
