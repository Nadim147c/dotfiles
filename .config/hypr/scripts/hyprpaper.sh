#!/bin/sh

if [ "$1" = "--startup" ]; then
    hyprpaper 2>&1 | tee -a ~/.local/share/logs/hyprpaper.log &
    while hyprctl hyprpaper listloaded | grep -Pq "Couldn\'t connect to.+hyprpaper.sock"; do
        sleep 0.1
    done
fi

current_wallpaper=$(hyprctl hyprpaper listactive | awk 'NR==1' | grep -o '/.\+')
wallpaper=$(find -L ~/Pictures/Wallpapers/ -type f | grep -P '\.(jpg|jpeg|png)$' | grep -v "$current_wallpaper" | shuf -n1)

matugen image "$wallpaper" 2>&1 | tee -a ~/.local/share/logs/hyprpaper.log

hyprctl hyprpaper unload all 2>&1 | tee -a ~/.local/share/logs/hyprpaper.log
hyprctl hyprpaper preload "$wallpaper" 2>&1 | tee -a ~/.local/share/logs/hyprpaper.log
hyprctl hyprpaper wallpaper ",$wallpaper" 2>&1 | tee -a ~/.local/share/logs/hyprpaper.log
