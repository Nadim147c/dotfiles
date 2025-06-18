#!/bin/sh

VOLUME_LINE=$(wpctl get-volume @DEFAULT_SINK@)

case "$1" in
  --volume)
    echo "$VOLUME_LINE" | sed -E 's/Volume: 0\.([0-9]+).*/\1/'
    ;;
  --muted)
    echo "$VOLUME_LINE" | grep -q '\[MUTED\]' && echo true || echo false
    ;;
  *)
    echo "Usage: $0 [--volume | --muted]"
    exit 1
    ;;
esac

