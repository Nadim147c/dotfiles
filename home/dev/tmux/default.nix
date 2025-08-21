{
    config,
    lib,
    pkgs,
    ...
}: let
    tmuxSmartRight = pkgs.callPackage ./right.nix {};
    tmuxSmartLeft = pkgs.callPackage ./left.nix {};
in {
    home.activation.reloadTmux = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.tmux}/bin/tmux source-file ${config.xdg.configHome}/tmux/tmux.conf
    '';

    programs.tmux = {
        enable = true;
        baseIndex = 1;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-o";
        sensibleOnTop = true;
        shell = "${pkgs.fish}/bin/fish";
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

            source ${config.xdg.configHome}/tmux/colors.conf
        '';

        plugins = with pkgs; [
            tmuxPlugins.cpu
            tmuxPlugins.better-mouse-mode
            tmuxPlugins.tmux-fzf
            tmuxPlugins.yank
        ];
    };
}
