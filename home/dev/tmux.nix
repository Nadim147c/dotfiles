{pkgs, ...}: {
    programs.tmux = {
        enable = true;
        keyMode = "vi";
        terminal = "xterm-256color";
        shell = "${pkgs.fish}/bin/fish";
        mouse = true;
        baseIndex = 0;
        plugins = with pkgs; [
            tmuxPlugins.cpu
            tmuxPlugins.better-mouse-mode
            {
                plugin = tmuxPlugins.catppuccin;
                extraConfig = ''
                    set -g @catppuccin_flavor 'mocha'
                    set -g @catppuccin_pane_background_color ""
                '';
            }
            {
                plugin = tmuxPlugins.continuum;
                extraConfig = ''
                    set -g @continuum-restore 'on'
                    set -g @continuum-save-interval '60' # minutes
                '';
            }
        ];
    };
}
