#!/bin/sh

artist=$(playerctl metadata xesam:artist)
title=$(playerctl metadata xesam:title)

max_length=70
case "$1" in
--title)
    if [ ${#title} -gt $max_length ]; then
        echo "$(echo "$title" | head -c $max_length)..."
        exit
    fi
    echo "$title"
    ;;
--artist)
    if [ ${#artist} -gt $max_length ]; then
        echo "$(echo "$artist" | head -c $max_length)..."
        exit
    fi
    echo "$artist"
    ;;
esac
