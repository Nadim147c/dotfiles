{
    constants,
    delib,
    host,
    inputs,
    pkgs,
    xdg,
    ...
}: let
    tmux-navigate = pkgs.writeShellScript "tmux-navigate.sh" ''
        if [ $# -lt 1 ]; then
            echo "Usage: $0 <left|right|up|down>" >&2
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
            echo "Usage: $0 <left|right|up|down>" >&2
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
in
    delib.module {
        name = "programs.tmux";

        options = delib.singleEnableOption host.guiFeatured;

        home.ifEnabled = {
            home.activation.reloadTmux = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
                tmux source-file ${xdg.configHome}/tmux/tmux.conf || true
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
                    bind -n M-h run-shell "${tmux-navigate} h"
                    bind -n M-j run-shell "${tmux-navigate} j"
                    bind -n M-k run-shell "${tmux-navigate} k"
                    bind -n M-l run-shell "${tmux-navigate} l"
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

                    set -as terminal-features ",*:hyperlinks"
                '';

                plugins = with pkgs; [
                    tmuxPlugins.better-mouse-mode
                    tmuxPlugins.tmux-fzf
                    tmuxPlugins.yank
                ];
            };
        };
    }
