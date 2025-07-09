#!/bin/sh

# Usage: compile-scss.sh path/to/file.scss

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/file.scss"
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

DIR="$(dirname "$INPUT")"
BASE="$(basename "$INPUT" .scss)"
OUTPUT="$DIR/$BASE.css"
TMPFILE="$(mktemp "$DIR/$BASE.XXXXXX.css")"

# Compile SCSS to a temporary file
if sass --no-cache --sourcemap=none "$INPUT" "$TMPFILE"; then
    # Use install to safely move the file (preserves permissions, atomic)
    install -m 644 "$TMPFILE" "$OUTPUT"
    echo "Compiled $INPUT -> $OUTPUT"
    rm -f "$TMPFILE"
else
    echo "SCSS compilation failed."
    rm -f "$TMPFILE"
    exit 1
fi
