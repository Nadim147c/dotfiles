{
    constants,
    delib,
    host,
    inputs,
    pkgs,
    xdg,
    ...
}: let
    tmuxSmartRight = pkgs.writeShellScript "tmux-right.sh" ''
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
    '';
    tmuxSmartLeft = pkgs.writeShellScript "tmux-left.sh" ''
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
    '';
in
    delib.module {
        name = "programs.tmux";

        options = delib.singleEnableOption host.guiFeatured;

        home.ifEnabled = {
            home.activation.reloadTmux = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
                ${pkgs.tmux}/bin/tmux source-file ${xdg.configHome}/tmux/tmux.conf || true
            '';

            home.packages = [pkgs.tmux-sessionizer];

            programs.tmux = {
                enable = true;
                baseIndex = 1;
                historyLimit = 10000;
                keyMode = "vi";
                mouse = true;
                prefix = "C-o";
                sensibleOnTop = true;
                shell = constants.shell;
                terminal = "xterm-256color";

                extraConfig = ''
                    # Smart Alt+h/l navigation
                    bind -n M-l run-shell "${tmuxSmartRight}"
                    bind -n M-h run-shell "${tmuxSmartLeft}"
                    bind -n M-p run-shell "tmux neww ${pkgs.tmux-sessionizer}/bin/tmux-sessionizer"

                    # Vertical pane movement
                    bind -n M-j select-pane -D
                    bind -n M-k select-pane -U

                    # Alt+n creates a new window
                    bind -n M-n new-window

                    set -g status-position top
                    set -g status-justify absolute-centre
                    set -g status-style "bg=default"
                    set -g window-status-current-style "fg=blue bold"
                    set -g status-right ""
                    set -g status-left "#S"
                    set -g status-left-length 100
                    set -sg escape-time 10

                    source ${xdg.configHome}/tmux/colors.conf

                    set -g popup-border-style "fg=black"
                    set -g popup-border-lines "rounded"
                '';

                plugins = with pkgs; [
                    tmuxPlugins.better-mouse-mode
                    tmuxPlugins.tmux-fzf
                    tmuxPlugins.yank
                ];
            };
        };
    }
