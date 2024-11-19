#!/bin/sh

url=$(playerctl metadata mpris:artUrl)
artist=$(playerctl metadata xesam:artist)
album=$(playerctl metadata xesam:album)
metadata=$(printf '%s' "$artist-$album")

if [ ! -d "$HOME/.cache/albumart" ]; then
    mkdir -pv "$HOME/.cache/albumart"
fi

if [ "$url" = "No player found" ]; then
    exit
elif [ -f "$HOME/.cache/albumart/$metadata.png" ]; then
    echo "$HOME/.cache/albumart/$metadata.png"
else
    curl -s "$url" -o "$HOME/.cache/albumart/$metadata.png"
    echo "$HOME/.cache/albumart/$metadata.png"
fi
