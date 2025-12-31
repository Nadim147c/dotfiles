{
  constants,
  delib,
  hmlib,
  host,
  pkgs,
  xdg,
  func,
  ...
}:
let
  reloadConfig = /* bash */ ''
    tmux source-file ${xdg.configHome}/tmux/tmux.conf || true
  '';
in
delib.module {
  name = "programs.tmux";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.activation.reloadTmux = hmlib.dag.entryAfter [ "writeBoundary" ] reloadConfig;

    programs = {
      rong.settings.themes = func.mkList {
        target = "colors.tmux";
        links = "${xdg.configHome}/tmux/colors.conf";
        cmds = reloadConfig;
      };

      fish.interactiveShellInit = /* fish */ ''
        for mode in default insert visual normal
            bind -M $mode \ep 'tmux-sessionizer'
        end
      '';

      tmux = {
        inherit (constants) shell;
        enable = true;
        baseIndex = 1;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-o";
        sensibleOnTop = true;
        terminal = "xterm-256color";

        extraConfig = /* tmux */ ''
          # Smart Alt+h/l navigation
          bind -n M-h run-shell "tmux-navigate h"
          bind -n M-j run-shell "tmux-navigate j"
          bind -n M-k run-shell "tmux-navigate k"
          bind -n M-l run-shell "tmux-navigate l"
          bind -n M-p run-shell "tmux neww tmux-sessionizer"

          # Vertical pane movement
          bind -n M-j select-pane -D
          bind -n M-k select-pane -U

          # Alt+n creates a new window
          bind -n M-n new-window

          set -g status-position top
          set -g status-justify absolute-centre
          set -g status-right ""
          set -g status-left "#S"
          set -g status-left-length 100
          set -sg escape-time 10

          source ${xdg.configHome}/tmux/colors.conf

          set -g popup-border-style "fg=#{@rong_outline}"
          set -g popup-border-lines "rounded"

          set -g status-style "bg=default,fg=#{@rong_on_background}"
          set -g window-status-current-style "bg=default,fg=#{@rong_color_2}"

          set -as terminal-features ",*:hyperlinks"
        '';

        plugins = [ pkgs.tmuxPlugins.better-mouse-mode ];
      };
    };
  };
}
