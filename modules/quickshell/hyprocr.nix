{
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "hyprocr";
    package = pkgs.writeShellScriptBin "hyprocr.sh" ''
        pkill slurp || true

        DIR=$(mktemp -d)

        ${pkgs.hyprshot}/bin/hyprshot -m region -s -o "$DIR" -f image.png
        ${pkgs.tesseract4}/bin/tesseract "$DIR/image.png" "$DIR/text"

        TEXT=$(cat "$DIR/text.txt")
        rm -rf "$DIR"

        echo "$TEXT"
        echo "$TEXT" | wl-copy

        notify-send "OCR" "Copied to clipboard: $TEXT"
    '';
}
