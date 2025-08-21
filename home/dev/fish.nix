{
    pkgs,
    config,
    ...
}: let
    # fix: home-manager converts shell variables from sh and sets a global variable
    # __HM_SESS_VARS_SOURCED=1. It then checks this variable before sourcing,
    # which makes fish ignore all other shell variables.
    translatedSessionVariables = pkgs.runCommandLocal "hm-session-vars-fixed.fish" {} ''
        (echo "set __HM_SESS_VARS_SOURCED" # reset __HM_SESS_VARS_SOURCED so that shell var is set
        ${pkgs.buildPackages.babelfish}/bin/babelfish \
        <${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh) > $out
    '';
in {
    programs.fish = {
        enable = true;
        shellInit = "source ${translatedSessionVariables}";
        interactiveShellInit =
            # fish
            ''
                set -U fish_greeting
                set fish_color_command blue --bold
                set fish_color_redirection yellow --bold
                set fish_color_option red
                set fish_pager_color_prefix green --bold
                set fish_pager_color_completion blue --bold
                set fish_pager_color_description white --bold
                fish_vi_key_bindings --no-erase
                # Functions
                function field -a n
                    awk "{ print \$$n }"
                end

                ${pkgs.chromashift}/bin/cshift alias fish | source

                for mode in default insert visual normal
                    bind -M $mode \ep '${pkgs.tmux-sessionizer}/bin/tmux-sessionizer'
                end
            '';
        generateCompletions = false;
    };
}
