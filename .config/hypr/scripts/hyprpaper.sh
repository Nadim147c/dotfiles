#!/bin/sh

_hyprpaper_log() {
    "$@" 2>&1 | tee -a ~/.local/share/logs/hyprpaper.log
}

_hyprpaper_get_wallpaper() {
    current_wallpaper=$(hyprctl hyprpaper listactive | awk 'NR==1' | grep -o '/.\+' || echo "<IGNORE_ME>")

    find -L ~/Pictures/Wallpapers/ -type f |
        grep -P '\.(jpg|jpeg|png)$' |
        grep -Fv "$current_wallpaper" |
        grep -Fv "/Pictures/Wallpapers/walpaper.jpg" |
        shuf -n1
}

_hyprpaper_move_wallpaper() {
    extension="${1##*.}"
    if [ "$extension" = "jpg" ] || [ "$extension" = "jpeg" ]; then
        cp "$1" ~/Pictures/Wallpapers/walpaper.jpg
    else
        magick "$1" ~/Pictures/Wallpapers/walpaper.jpg
    fi
}

_hyprpaper_gen_colors() {
    _hyprpaper_log echo "Generating color from '$1'"
    _hyprpaper_log matugen image "$1" --show-colors
}

_hyprpaper_set_wallpaper() {
    _hyprpaper_log hyprctl hyprpaper unload all
    _hyprpaper_log hyprctl hyprpaper preload "$1"
    _hyprpaper_log hyprctl hyprpaper wallpaper ",$1"
}

wallpaper=$(_hyprpaper_get_wallpaper)

_hyprpaper_gen_colors "$wallpaper"

if [ "$1" = "--startup" ]; then
    _hyprpaper_move_wallpaper "$wallpaper" &
    _hyprpaper_log hyprpaper &
else
    _hyprpaper_set_wallpaper "$wallpaper"
    _hyprpaper_move_wallpaper "$wallpaper"
fi
