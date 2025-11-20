{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.fish";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled = {
        programs.fish = {
            enable = true;
            interactiveShellInit = ''
                set -U fish_greeting
                set fish_color_command blue --bold
                set fish_color_redirection yellow --bold
                set fish_color_option red
                set fish_pager_color_prefix green --bold
                set fish_pager_color_completion blue --bold
                set fish_pager_color_description white --bold

                for mode in default insert visual normal
                    bind -M $mode \ep '${pkgs.tmux-sessionizer}/bin/tmux-sessionizer'
                end

                fish_vi_key_bindings --no-erase
            '';
            generateCompletions = false;
            functions.fish_command_not_found.body = ''
                nix run nixpkgs#$argv[1] -- $argv[2..]
            '';
        };
    };

    nixos.ifEnabled.environment.pathsToLink = [
        "/share/fish/vendor_completions.d"
    ];
}
