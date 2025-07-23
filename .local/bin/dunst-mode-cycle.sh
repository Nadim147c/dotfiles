#!/bin/sh

current=$(dunstctl get-pause-level)

case "$current" in
  0) next=1 ;;
  1) next=2 ;;
  2) next=100 ;;
  100) next=0 ;;
  *) next=0 ;;
esac

dunstctl set-pause-level "$next"
eww update notification_mode="$next"
