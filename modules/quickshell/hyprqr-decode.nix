{
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "hyprqr-decode";
    package = pkgs.writeShellScriptBin "hyprqr-decode.sh" ''
        pkill slurp || true

        TEXT=$(${pkgs.hyprshot}/bin/hyprshot -m region --raw | ${pkgs.qrtool}/bin/qrtool decode 2>/dev/null)

        if [ -z "$TEXT" ]; then
          notify-send "QR Decode" "No QR code detected."
          exit 1
        fi

        echo "$TEXT"
        echo "$TEXT" | wl-copy

        notify-send "QR Decode" "Copied to clipboard: $TEXT"
    '';
}
