{pkgs, ...}: let
    image-detect = pkgs.writeShellApplication {
        name = "image-detect";

        runtimeInputs = with pkgs; [file fd coreutils];

        text = ''
            # Set the base directory (default to current if not provided)
            BASE_DIR="''${1:-.}"

            # Walk through all files with no extension
            fd '^[^\.]+$' --type f "$BASE_DIR" | while read -r file; do
                # Use the `file` command to detect MIME type
                mime_type=$(file --mime-type -b "$file")

                # Extract extension from MIME type
                case "$mime_type" in
                image/jpeg)
                    ext="jpg"
                    ;;
                image/png)
                    ext="png"
                    ;;
                image/gif)
                    ext="gif"
                    ;;
                image/webp)
                    ext="webp"
                    ;;
                image/bmp)
                    ext="bmp"
                    ;;
                image/tiff)
                    ext="tiff"
                    ;;
                *)
                    echo "Skipping unknown file type: $file ($mime_type)"
                    continue
                    ;;
                esac

                # Rename the file with the appropriate extension
                new_file="$(dirname "$file")/$(uuidgen).''${ext}"
                if [[ -e "$new_file" ]]; then
                    echo "Cannot rename $file to $new_file: target exists."
                else
                    mv -v "$file" "$new_file"
                fi
            done
        '';
    };
in {
    home.packages = [image-detect];
}
