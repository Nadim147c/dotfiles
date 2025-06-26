#!/bin/bash

# Set the base directory (default to current if not provided)
BASE_DIR="${1:-.}"
FORCE=0

# Check for --force flag
if [[ "$1" == "--force" ]]; then
    FORCE=1
    BASE_DIR="${2:-.}"
elif [[ "$2" == "--force" ]]; then
    FORCE=1
    BASE_DIR="${1:-.}"
fi

if [[ "$FORCE" -ne 1 ]]; then
    read -p "You're about to rename all files (recursively) in '$BASE_DIR'. Proceed? [y/N]: " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || {
        echo "Aborted."
        exit 1
    }
fi

find "$BASE_DIR" -type f | while read -r file; do
    filename=$(basename -- "$file")
    ext="${filename##*.}"
    [[ "$filename" == "$ext" ]] && ext="" # No extension

    new_file="$(dirname "$file")/$(uuidgen)"
    [[ -n "$ext" ]] && new_file="${new_file}.${ext}"

    if [[ -e "$new_file" ]]; then
        echo "Cannot rename $file to $new_file: target exists."
    else
        mv -v "$file" "$new_file"
    fi
done
