#!/bin/sh

wallpaper=$(find -L "$HOME/Pictures/Wallpapers/" -type f | grep -P '\.(jpg|jpeg|png)$' | shuf -n1)

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$wallpaper"
hyprctl hyprpaper wallpaper ",$wallpaper"
