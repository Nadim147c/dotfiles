#!/usr/bin/sh


if [[ "$2" == "up" ]]; then
    playerctl --player="$1" volume 0.05+
else
    playerctl --player="$1" volume 0.05-
fi
