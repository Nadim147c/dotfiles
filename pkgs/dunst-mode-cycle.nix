{
    writeShellApplication,
    dunst,
}:
writeShellApplication {
    name = "dunst-mode-cycle";

    runtimeInputs = [dunst];

    text = ''
        current=$(dunstctl get-pause-level)

        case "$current" in
          0) next=1 ;;
          1) next=2 ;;
          2) next=3 ;;
          3) next=0 ;;
          *) next=0 ;;
        esac

        dunstctl set-pause-level "$next"
        if command -v eww 2>/dev/null >/dev/null ; then
            eww update notification_mode="$next"
        fi
    '';
}
