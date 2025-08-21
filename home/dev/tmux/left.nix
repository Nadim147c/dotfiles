{writeShellScript}:
writeShellScript "tmux-left.sh" ''

    #!/usr/bin/env bash
    # tmux-smart-left.sh

    left=$(tmux list-panes -F '#{pane_index} #{pane_active} #{pane_at_left}' \
           | awk '$2=="0" && $3=="1" {print $1}' | head -n1)

    if [ -n "$left" ]; then
        tmux select-pane -t "$left"
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

    indices=()
    for w in "''${windows[@]}"; do
        idx=''${w#*:}
        indices+=("$idx")
    done

    for i in "''${!indices[@]}"; do
        if [ "''${indices[$i]}" -eq "$current" ]; then
            pos=$i
            break
        fi
    done

    prev=$(( (pos - 1 + ''${#indices[@]}) % ''${#indices[@]} ))
    tmux select-window -t "''${indices[$prev]}"
''
