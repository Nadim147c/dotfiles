#!/bin/bash

# File Renamer Utility
# Renames files (recursively in a directory or individually) with UUIDs
# Usage:
#   ./script [--force] [<directory-or-file>]
#   If <directory-or-file> is not provided, defaults to current directory
#   --force: Skip confirmation prompt
# Features:
#   - Preserves file extensions
#   - Handles files with spaces and special characters
#   - Prevents overwriting existing files
#   - Recursive directory processing
#   - Single file renaming mode

# Set default base path
TARGET_PATH="${1:-.}"
FORCE=0

# Check for --force flag and adjust target path
if [[ "$1" == "--force" ]]; then
    FORCE=1
    TARGET_PATH="${2:-.}"
elif [[ "$2" == "--force" ]]; then
    FORCE=1
    TARGET_PATH="${1:-.}"
fi

# Exit if target doesn't exist
if [[ ! -e "$TARGET_PATH" ]]; then
    echo "Error: '$TARGET_PATH' does not exist" >&2
    exit 1
fi

# Single file mode
if [[ -f "$TARGET_PATH" ]]; then
    file="$TARGET_PATH"
    filename=$(basename -- "$file")
    ext="${filename##*.}"
    [[ "$filename" == "$ext" ]] && ext="" # Handle extensionless files

    new_file="$(dirname "$file")/$(uuidgen)"
    [[ -n "$ext" ]] && new_file="${new_file}.${ext}"

    if [[ -e "$new_file" ]]; then
        echo "Cannot rename $file to $new_file: target exists." >&2
        exit 1
    else
        mv -v "$file" "$new_file"
        exit 0
    fi
fi

# Directory mode - handle confirmation
if [[ "$FORCE" -ne 1 ]]; then
    read -p "You're about to rename all files in '$TARGET_PATH'. Proceed? [y/N]: " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || {
        echo "Aborted."
        exit 1
    }
fi

# Process directory recursively
fd . "$TARGET_PATH" --type f --max-depth 1 | while IFS= read -r file; do
    filename=$(basename -- "$file")
    ext="${filename##*.}"
    [[ "$filename" == "$ext" ]] && ext="" # Handle extensionless files

    new_file="$(dirname "$file")/$(uuidgen)"
    [[ -n "$ext" ]] && new_file="${new_file}.${ext}"

    if [[ -e "$new_file" ]]; then
        echo "Cannot rename $file to $new_file: target exists." >&2
    else
        mv -v "$file" "$new_file"
    fi
done
