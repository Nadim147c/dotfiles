#!/bin/sh

waypaper --restore 2>/dev/null || true

# Fallback workspace
workspace=5

# Get the Hyprland socket path
uri="UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Read events from the socket
socat -U - "$uri" | while IFS= read -r line; do
    if printf %s "$line" | grep -q "^workspacev2>>"; then
        # Extract workspace id
        id=$(printf "%s\n" "$line" | sed 's/^workspacev2>>//' | awk -F',' '{print $1}')
        workspace="$id"
    fi

    # Check if workspace has no non-floating clients
    if hyprctl clients -j | jq -e --argjson ws "$workspace" \
        '[.[] | select(.workspace.id == $ws and (.floating | not))] | length == 0' >/dev/null; then
        echo "Playing"
        printf 'set pause no\n' | socat - /tmp/mpv-socket-All
    else
        echo "Pausing"
        printf 'set pause yes\n' | socat - /tmp/mpv-socket-All
    fi
done
