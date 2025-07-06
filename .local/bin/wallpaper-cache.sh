#!/bin/bash
set -e

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-cache"

# Check dependencies
if ! command -v magick &>/dev/null; then
    echo "Error: ImageMagick 'magick' command not found" >&2
    exit 1
fi
if ! command -v jq &>/dev/null; then
    echo "Error: 'jq' command not found" >&2
    exit 1
fi

mkdir -p "$CACHE_DIR"

cache_image() {
    local src="$1"
    local filename=$(basename "$src")
    local cache_file="$CACHE_DIR/$filename"

    if [[ ! -f "$cache_file" ]] || [[ "$src" -nt "$cache_file" ]]; then
        echo "caching $src"
        magick "$src" -resize 300x -strip -quality 80 "$cache_file"
    fi
}

case "$1" in
"cache")
    # Cache all images in wallpaper directory
    while IFS= read -r -d $'\0' img; do
        cache_image "$img"
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0)
    ;;
"list")
    # Generate JSON array using jq for compact output
    while IFS= read -r -d $'\0' img; do
        filename=$(basename "$img")
        cache_file="$CACHE_DIR/$filename"

        if [[ -f "$cache_file" ]]; then
            echo "$cache_file"
        else
            echo "$img"
        fi
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0) |
        jq -R -n '[inputs]' -c
    ;;
"resolve")
    if [[ -z "$2" ]]; then
        echo "Error: No path specified for resolution" >&2
        exit 1
    fi

    if [[ "$2" == "$CACHE_DIR/"* ]]; then
        filename=$(basename "$2")
        original=$(find "$WALLPAPER_DIR" -name "$filename" -print -quit)
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
