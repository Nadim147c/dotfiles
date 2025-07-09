#!/bin/sh

# coffee.sh - Keep your computer awake like it's had too much coffee
# Usage:
#   ./coffee.sh --check   # Checks if caffeine mode is active
#   ./coffee.sh --toggle  # Toggle caffeine mode with notification

COFFEE_FILE="/tmp/coffee"
NOTIFY_TIMEOUT=3000 # 3 second notification timeout

# Show coffee-themed notification if possible
brew_notification() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -t "$NOTIFY_TIMEOUT" "Coffee Mode" "$1"
    fi
}

case "$1" in
--check)
    if [ -e "$COFFEE_FILE" ]; then
        echo true
        exit 0
    else
        echo false
        exit 1
    fi
    ;;
--toggle)
    if [ -e "$COFFEE_FILE" ]; then
        rm -f "$COFFEE_FILE"
        brew_notification "Your computer has sobered up. It might fall asleep now."
    else
        : >"$COFFEE_FILE"
        brew_notification "Your computer has been caffeinated! It will stay awake."
    fi
    ;;
*)
    echo "Usage: $0 --check|--toggle" >&2
    exit 1
    ;;
esac
