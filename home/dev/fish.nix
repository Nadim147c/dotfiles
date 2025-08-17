{
    pkgs,
    config,
    ...
}: let
    # fix: for some reason home-manager converts shell variable from sh and set global variable to
    # __HM_SESS_VARS_SOURCED=1 and check this variable before sourcing which makes fish ignore the
    # all there shell variable
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
                # Functions
                function field -a n
                    awk "{ print \$$n }"
                end

                ${pkgs.chromashift}/bin/cshift alias fish | source
            '';
        generateCompletions = false;
    };
}
