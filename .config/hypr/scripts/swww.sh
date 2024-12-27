#!/bin/sh

_get_wallpaper() {
    current_wallpaper=$(swww query | grep -o '/.\+$' || echo "<IGNORE_ME>")

    find -L ~/Pictures/Wallpapers/ -type f |
        grep -P '\.(jpg|jpeg|png|webm)$' |
        grep -Fv "$current_wallpaper" |
        shuf -n1
}

_gen_colors() {
    echo "Generating color from $1"
    if [ -n "$wallpaper" ]; then
        wal -nse -i "$1" &
        matugen image "$1" --verbose
    else
        matugen color hex "#00ff00" --verbose
    fi

    CACHE="$HOME/.cache/matugen/"
    CONFIG="$HOME/.config/"
    install -vDm644 "$CACHE/discord.css" "$CONFIG/vesktop/settings/quickCss.css"
    install -vDm644 "$CACHE/spicetify.ini" "$CONFIG/spicetify/Themes/Sleek/color.ini"
}

_set_wallpaper() {
    cursor_pos=$(hyprctl cursorpos | sed 's/ //g')

    if ! echo "$cursor_pos" | grep -Pq "^[0-9]+,[0-9]+$"; then
        cursor_pos="0,0"
    fi

    echo "Setting wallpaper ($cursor_pos) '$1'"

    swww img \
        --transition-type=grow \
        --transition-fps=30 \
        --invert-y --transition-pos="$cursor_pos" \
        --transition-bezier='.43,1.19,1,.4' \
        --transition-duration='0.6' \
        "$1"
}

if [ -z "$1" ]; then
    wallpaper=$(_get_wallpaper)
else
    wallpaper=$1
fi

echo "Selected wallpaper is '$wallpaper'"

_set_wallpaper "$wallpaper" &
_gen_colors "$wallpaper"
