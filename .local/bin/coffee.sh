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

is_caffeinated() { [ -e "$COFFEE_FILE" ] && return 0 || return 1; }

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
--lock)
    is_caffeinated && exit 0
    # Use fork to ensure hyprlock doesn't die after locking the session
    # 'fork' command can be found in
    # https://github.com/Nadim147c/dotfiles/blob/ec6f6cf13eb50247d42803cf1de982b35c8f4cfa/go/cmd/fork/main.go
    fork hyprlock
    exit 0
    ;;
--sleep)
    is_caffeinated && exit 0
    systemctl suspend
    exit 0
    ;;
--run)
    is_caffeinated && exit 0
    [ -n "$2" ] && {
        shift
        eval "$@"
    }
    exit 0
    ;;
*)
    echo "Usage: $0 --check|--toggle|--lock|--sleep|--run \"command\""
    brew_notification "Invalid command: $1"
    exit 1
    ;;
esac
