{
    delib,
    pkgs,
    config,
    ...
}:
delib.module {
    name = "programs.fish";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username}.home;
        translatedSessionVariables = pkgs.runCommandLocal "hm-session-vars-fixed.fish" {} ''
            (echo "set __HM_SESS_VARS_SOURCED" # reset __HM_SESS_VARS_SOURCED so that shell var is set
            ${pkgs.buildPackages.babelfish}/bin/babelfish \
            <${home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh) > $out
        '';
    in {
        home.packages = with pkgs; [chromashift];
        programs.fish = {
            enable = true;
            shellInit = "source ${translatedSessionVariables}";
            interactiveShellInit = ''
                set -gx __HM_SESS_VARS_SOURCED
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

                for mode in default insert visual normal
                    bind -M $mode \ep '${pkgs.tmux-sessionizer}/bin/tmux-sessionizer'
                end

                ${pkgs.chromashift}/bin/cshift alias fish | source
            '';
            generateCompletions = false;
            functions.fish_command_not_found.body = ''
                nix run nixpkgs#$argv[1] -- $argv[2..]
            '';
        };
    };
}
