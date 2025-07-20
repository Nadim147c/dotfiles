#!/bin/bash
set -e

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-cache"
mkdir -p "$CACHE_DIR"

check_binaries() {
    local missing=0
    for bin in "$@"; do
        if ! command -v "$bin" &>/dev/null; then
            echo "Missing Binary: $bin"
            missing=1
        fi
    done

    if [[ $missing != 0 ]]; then
        exit 1
    fi
}

check_binaries fd jq magick

list_image() { fd --glob '*.{png,jpg,jpeg,webp}' "$1"; }
find_image() { fd --fixed-strings "$filename" --max-results 1 "$1"; }

case "$1" in
"cache")
    # Cache Wallpapers
    list_image "$WALLPAPER_DIR" | while read -r src; do
        filename=$(basename "$src")
        cache_file="$CACHE_DIR/$filename"

        if [[ ! -f "$cache_file" ]] || [[ "$src" -nt "$cache_file" ]]; then
            echo "Caching $src"
            magick "$src" -resize 300x -strip -quality 80 "$cache_file"
        fi
    done

    # Clear up the orphaned cached
    list_image "$CACHE_DIR" | while read -r cache_file; do
        filename=$(basename "$cache_file")
        original=$(find_image "$WALLPAPER_DIR")
        if [[ -z "$original" ]]; then
            echo "Deleting orphaned cache file: $cache_file"
            rm -f "$cache_file"
        fi
    done
    ;;
"list")
    # Generate JSON array using jq for compact output
    list_image "$WALLPAPER_DIR" | while read -r img; do
        filename=$(basename "$img")
        cache_file="$CACHE_DIR/$filename"

        if [[ -f "$cache_file" ]]; then
            echo "$cache_file"
        else
            echo "$img"
        fi
    done | jq -R -n '[inputs]' -c
    ;;
"resolve")
    if [[ -z "$2" ]]; then
        echo "Error: No path specified for resolution" >&2
        exit 1
    fi

    if [[ "$2" == "$CACHE_DIR/"* ]]; then
        filename=$(basename "$2")
        original=$(find_image "$WALLPAPER_DIR")
        if [[ -n "$original" ]]; then
            echo "$original"
        else
            echo "Error: Original image not found for $2" >&2
            exit 1
        fi
    else
        echo "$2"
    fi
    ;;
*)
    echo "Usage: $0 {cache|list|resolve <path>}" >&2
    exit 1
    ;;
esac
