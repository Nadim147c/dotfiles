{
  coreutils,
  fd,
  systemd,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "wallpaper.sh";
  runtimeInputs = [
    coreutils
    fd
    systemd
  ];

  text = ''
    WALLPAPER_DIR="$(systemd-path user-videos)/wallpapers"
    STATE_FILE="$(systemd-path user-state-private)/wallpaper.state"

    find_wallpaper() {
        mkdir -p "$WALLPAPER_DIR"
        fd '\.(mp4|mkv|webm|gif)$' "$WALLPAPER_DIR" | shuf -n1
    }

    set_wallpaper() {
        printf "Setting wallpaper %q\n" "$1" >&2
        touch "$1"
        mkdir -p "$(dirname "$STATE_FILE")"
        echo "$1" > "$STATE_FILE"
    }

    if [[ $# -ge 1 ]]; then
        wallpaper="$1"
    else
        wallpaper=$(find_wallpaper)
    fi

    if [ -z "$wallpaper" ]; then
        echo "Error: No suitable wallpaper found" >&2
        exit 1
    fi

    set_wallpaper "$wallpaper"
    rong video "$wallpaper"
  '';
}
