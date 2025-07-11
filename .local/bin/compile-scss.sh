#!/bin/sh

# Usage: compile-scss.sh [--watch] path/to/file.scss

WATCH_MODE=false

if [ "$1" = "--watch" ]; then
    WATCH_MODE=true
    shift
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [--watch] path/to/file.scss"
    exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "Error: File '$INPUT' does not exist."
    exit 1
fi

if ! command -v sass >/dev/null 2>&1; then
    echo "Error: 'sass' command not found. Please install Dart Sass."
    exit 1
fi

if $WATCH_MODE && ! command -v inotifywait >/dev/null 2>&1; then
    echo "Error: 'inotifywait' command not found. Please install inotify-tools."
    exit 1
fi

compile_scss() {
    local INPUT="$1"
    local DIR="$(dirname "$INPUT")"
    local BASE="$(basename "$INPUT" .scss)"
    local OUTPUT="$DIR/$BASE.css"
    local TMPFILE="$(mktemp "$DIR/$BASE.XXXXXX.css")"

    # Compile SCSS to a temporary file
    if sass --no-cache --sourcemap=none "$INPUT" "$TMPFILE"; then
        # Use install to safely move the file (preserves permissions, atomic)
        install -m 644 "$TMPFILE" "$OUTPUT"
        echo "Compiled $INPUT -> $OUTPUT"
        rm -f "$TMPFILE"
    else
        echo "SCSS compilation failed."
        rm -f "$TMPFILE"
        return 1
    fi
}

# Initial compilation
compile_scss "$INPUT"

if $WATCH_MODE; then
    echo "Watching for changes in $INPUT..."
    while true; do
        inotifywait -e close_write -e modify -e move -e create -e delete --exclude '\.css$' "$INPUT" "$(dirname "$INPUT")"
        compile_scss "$INPUT"
    done
fi
