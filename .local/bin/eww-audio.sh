#!/bin/sh

case "$1" in
--set-volume)
    if echo "$2" | rg -q '\d+%$'; then
        wpctl set-volume @DEFAULT_SINK@ "$2"
    else
        swayosd-client --output-volume "$2"
    fi

    VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | sed -E 's/Volume: 0\.([0-9]+).*/\1/')
    eww update volume_value="$VOLUME"
    echo "$VOLUME"
    ;;
--toggle-mute)
    swayosd-client --output-volume mute-toggle

    MUTED=$(wpctl get-volume @DEFAULT_SINK@ | rg -q '\[MUTED\]' && echo true || echo false)
    eww update volume_muted="$MUTED"
    echo "$MUTED"
    ;;
--scroll)
    if [[ "$2" == "up" ]]; then
        eww-audio.sh --set-volume "+2"
    else
        eww-audio.sh --set-volume "-2"
    fi
    ;;
--volume)
    wpctl get-volume @DEFAULT_SINK@ | sed -E 's/Volume: 0\.([0-9]+).*/\1/'
    ;;
--muted)
    wpctl get-volume @DEFAULT_SINK@ | grep -q '\[MUTED\]' && echo true || echo false
    ;;
*)
    echo "Usage: $0 [--volume | --muted]"
    exit 1
    ;;
esac
