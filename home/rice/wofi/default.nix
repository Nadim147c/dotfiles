{
    config,
    pkgs,
    lib,
    ...
}: {
    home.activation.compileWofiSyle = lib.hm.dag.entryAfter ["writeBoundary"] # bash
    
    ''
        ${pkgs.coreutils}/bin/install -Dm466 ${./style.scss} ${config.xdg.configHome}/wofi/style.scss
        ${pkgs.compile-scss}/bin/compile-scss ${config.xdg.configHome}/wofi/style.scss
    '';

    programs.wofi = {
        enable = true;
        settings = {
            allow_images = true;
            show = "drun";
            term = "kitty";
            matching = "fuzzy";
            key_up = "Ctrl-p";
            key_down = "Ctrl-n";
        };
    };
}
