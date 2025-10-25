{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.vivid";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled = let
        vividCommand = "vivid generate catppuccin-mocha";
    in {
        home.packages = with pkgs; [vivid];
        programs.bash.initExtra = ''
            export LS_COLORS="$(${vividCommand})"
        '';

        programs.zsh.initContent = ''
            export LS_COLORS="$(${vividCommand})"
        '';

        programs.fish.interactiveShellInit = ''
            set -gx LS_COLORS "$(${vividCommand})"
        '';

        programs.nushell.extraEnv = ''
            $env.LS_COLORS = "$(${vividCommand})"
        '';
    };
}
