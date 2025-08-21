{writeShellScript}:
writeShellScript "tmux-right.sh" ''
    right=$(tmux list-panes -F '#{pane_index} #{pane_active} #{pane_at_right}' \
            | awk '$2=="0" && $3=="1" {print $1}' | head -n1)

    if [ -n "$right" ]; then
        tmux select-pane -t "$right"
        exit 0
    fi

    windows=($(tmux list-windows -F '#{window_active} #{window_index}' \
                | awk '{print $1":"$2}'))

    for w in "''${windows[@]}"; do
        IFS=':' read -r active idx <<< "$w"
        if [ "$active" -eq 1 ]; then
            current=$idx
            break
        fi
    done

    # Base index starts at 1, wrap-around
    indices=()
    for w in "''${windows[@]}"; do
        idx=''${w#*:}
        indices+=("$idx")
    done

    # Find position of current in indices
    for i in "''${!indices[@]}"; do
        if [ "''${indices[$i]}" -eq "$current" ]; then
            pos=$i
            break
        fi
    done

    next=$(( (pos + 1) % ''${#indices[@]} ))
    tmux select-window -t "''${indices[$next]}"
''
