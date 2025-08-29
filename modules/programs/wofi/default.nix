{
    config,
    delib,
    inputs,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "programs.wofi";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        configHome = config.home-manager.users.${username}.xdg.configHome;
    in {
        home.activation.compileWofiSyle = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${pkgs.coreutils}/bin/install -Dm466 ${./style.scss} ${configHome}/wofi/style.scss
            ${pkgs.compile-scss}/bin/compile-scss ${configHome}/wofi/style.scss
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
