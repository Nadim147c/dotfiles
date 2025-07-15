#!/bin/bash

QUIET=false
TOGGLE=false

while getopts "qt" opt; do
    case $opt in
        q) QUIET=true ;;
        t) TOGGLE=true ;;
        *) exit 1 ;;
    esac
done
shift $((OPTIND-1))

log() {
    if ! $QUIET; then
        echo "$1" >&2
    fi
}

log_error() {
    log "ERROR: $1"
}

list_sources() {
    pactl --format=json list sources | jq -c '
        map(select(.properties."device.class" == "sound"))
    '
}

get_default_source_name() {
    pactl --format=json info '@DEFAULT_SOURCE@' | jq -r '.default_source_name'
}

select_microphone() {
    local sources_json="$1"
    local mic

    # Find first running microphone
    mic=$(echo "$sources_json" | jq -c 'map(select(.state == "RUNNING")) | .[0]')
    if [ "$mic" != "null" ] && [ -n "$mic" ]; then
        echo "$mic"
        return
    fi

    # Find default microphone
    local default_name
    default_name=$(get_default_source_name) || return 1
    mic=$(echo "$sources_json" | jq -c --arg name "$default_name" 'map(select(.name == $name)) | .[0]')
    if [ "$mic" != "null" ] && [ -n "$mic" ]; then
        echo "$mic"
        return
    fi

    # Fallback to first available microphone
    mic=$(echo "$sources_json" | jq -c '.[0]')
    if [ "$mic" != "null" ] && [ -n "$mic" ]; then
        echo "$mic"
        return
    fi

    return 1
}

get_output() {
    local mic_json="$1"
    echo "$mic_json" | jq -c '
        (.state == "RUNNING") as $running |
        .mute as $mute |
        ($running and ($mute | not)) as $recording |
        {
            class: (if $recording then "recording" else "muted" end),
            display: $recording or $mute,
            name: .name,
            description: .description
        }
    '
}

# Main execution
sources_json=$(list_sources) || {
    log_error "Failed to list sources"
    exit 1
}

mic=$(select_microphone "$sources_json") || {
    log_error "No suitable microphone found"
    exit 1
}

if $TOGGLE; then
    name=$(echo "$mic" | jq -r '.name')
    if ! pactl set-source-mute "$name" toggle; then
        log_error "Failed to toggle microphone state"
        exit 1
    fi

    # Refresh data after toggle
    sources_json=$(list_sources) || {
        log_error "Failed to refresh sources after toggle"
        exit 1
    }
    mic=$(echo "$sources_json" | jq -c --arg name "$name" 'map(select(.name == $name)) | .[0]')
    if [ -z "$mic" ] || [ "$mic" = "null" ]; then
        log_error "Failed to find microphone after toggle"
        exit 1
    fi

    output=$(get_output "$mic")
    if ! eww update "microphone=$output"; then
        log_error "Failed to update eww variable"
        exit 1
    fi
else
    output=$(get_output "$mic")
    echo "$output"
fi
