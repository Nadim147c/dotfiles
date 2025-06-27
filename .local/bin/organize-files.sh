#!/bin/sh

organize_files() {
    # Set directory to current directory if not provided
    dir="${1:-$(pwd)}"
    dir="$(realpath "$dir")"

    # Confirmation prompt
    printf "Organize files in \033[1;34m%s\033[0m? [y/N] " "$dir"
    read -r answer

    # Check confirmation (simplified conditional)
    case "$answer" in
    [yY] | [yY][eE][sS]) ;;
    *)
        echo "Operation canceled"
        exit 0
        ;;
    esac

    echo "Starting organization..."

    # Find all files (not directories) in target directory
    find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
        # Get MIME type and basename
        type=$(file -b --mime-type "$file")
        base=$(basename "$file")
        category=""

        # Determine category from MIME type
        case "$type" in
        # Images
        image/*) category="Images" ;;

        # Videos
        video/*) category="Videos" ;;

        # Audio
        audio/*) category="Audio" ;;

        # Documents (including ebooks and office files)
        text/*) category="Documents" ;;
        application/pdf) category="Documents" ;;
        application/epub+zip) category="Documents" ;;
        application/x-mobipocket-ebook) category="Documents" ;;
        application/vnd.amazon.ebook) category="Documents" ;;
        application/msword) category="Documents" ;;
        application/vnd.openxmlformats-officedocument.wordprocessingml.*) category="Documents" ;;
        application/vnd.ms-excel) category="Documents" ;;
        application/vnd.openxmlformats-officedocument.spreadsheetml.*) category="Documents" ;;
        application/vnd.ms-powerpoint) category="Documents" ;;
        application/vnd.openxmlformats-officedocument.presentationml.*) category="Documents" ;;
        application/vnd.oasis.opendocument.*) category="Documents" ;;
        application/rtf) category="Documents" ;;
        application/x-tex) category="Documents" ;;
        application/x-latex) category="Documents" ;;

        # Archives
        application/zip) category="Archives" ;;
        application/x-tar) category="Archives" ;;
        application/x-gzip) category="Archives" ;;
        application/x-bzip2) category="Archives" ;;
        application/x-7z-compressed) category="Archives" ;;
        application/x-rar) category="Archives" ;;
        application/x-zip-compressed) category="Archives" ;;
        application/x-compress) category="Archives" ;;
        application/x-xz) category="Archives" ;;
        application/java-archive) category="Archives" ;;
        application/vnd.rar) category="Archives" ;;

        # Code
        text/x-c) category="Code" ;;
        text/x-c++) category="Code" ;;
        text/x-python) category="Code" ;;
        text/x-java) category="Code" ;;
        text/x-php) category="Code" ;;
        text/x-shellscript) category="Code" ;;
        text/css) category="Code" ;;
        text/javascript) category="Code" ;;
        application/javascript) category="Code" ;;
        application/json) category="Code" ;;
        application/xml) category="Code" ;;
        text/x-ruby) category="Code" ;;
        text/x-perl) category="Code" ;;
        text/x-lua) category="Code" ;;
        text/x-scala) category="Code" ;;
        text/x-swift) category="Code" ;;
        text/x-go) category="Code" ;;
        text/x-rust) category="Code" ;;
        text/markdown) category="Code" ;;
        text/x-makefile) category="Code" ;;
        text/html) category="Code" ;;
        application/x-sh) category="Code" ;;
        application/x-csh) category="Code" ;;
        application/x-httpd-php) category="Code" ;;

        # Configuration
        application/x-yaml) category="Configuration" ;;
        application/x-config) category="Configuration" ;;
        text/x-ini) category="Configuration" ;;
        text/x-properties) category="Configuration" ;;
        application/toml) category="Configuration" ;;
        application/x-toml) category="Configuration" ;;
        text/x-hcl) category="Configuration" ;;

        # Skip all other types
        *) continue ;;
        esac

        # Create destination directory and move file
        dest="$dir/$category"
        mkdir -p "$dest"
        mv -v "$file" "$dest/$base"
    done

    echo "Organization complete!"
}

# Call function with first argument or current directory
organize_files "${1:-}"
