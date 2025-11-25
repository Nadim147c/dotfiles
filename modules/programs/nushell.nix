{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.nushell";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.programs.nushell = {
        enable = true;
        settings = {
            show_banner = false;
            edit_mode = "vi";
            history.file_format = "sqlite";
            history.isolation = false;
            history.max_size = 5000000;
            history.sync_on_enter = true;
        };
        extraConfig = ''
            $env.config.completions.external.completer = $carapace_completer
        '';
    };
}
