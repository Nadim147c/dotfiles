{
    delib,
    inputs,
    pkgs,
    host,
    xdg,
    ...
}:
delib.module {
    name = "programs.wofi";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled = {
        home.activation.compileWofiSyle = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${pkgs.coreutils}/bin/install -Dm644 ${./style.scss} ${xdg.configHome}/wofi/style.scss
            ${pkgs.compile-scss}/bin/compile-scss ${xdg.configHome}/wofi/style.scss
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
    };
}
