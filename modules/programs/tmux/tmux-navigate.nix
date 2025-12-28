{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "tmux-navigate";
  partof = "programs.tmux";
  package = pkgs.writeShellScriptBin name ''
    if [ $# -lt 1 ]; then
        echo "Usage: ${name} <left|right|up|down>" >&2
        exit 2
    fi

    direction="''${1,,}"

    case "$direction" in
    left | h)
        check="#{pane_at_left}"
        select_flag="-L"
        fallback="-p"
        ;;
    right | l)
        check="#{pane_at_right}"
        select_flag="-R"
        fallback="-n"
        ;;
    up | k)
        check="#{pane_at_top}"
        select_flag="-U"
        fallback="-p"
        ;;
    down | j)
        check="#{pane_at_bottom}"
        select_flag="-D"
        fallback="-n"
        ;;
    *)
        echo "Unknown direction: $direction" >&2
        echo "Usage: ${name} <left|right|up|down>" >&2
        exit 3
        ;;
    esac

    # Ask tmux whether a pane exists in that direction for the current pane
    on_edge=$(tmux display-message -p -F "$check" 2>/dev/null || echo 0)

    if [[ "$on_edge" != "1" ]]; then
        tmux select-pane "$select_flag"
    else
        tmux select-window "$fallback" || true
    fi
  '';

}
