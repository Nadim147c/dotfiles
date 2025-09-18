{
    config,
    delib,
    host,
    inputs,
    pkgs,
    ...
}:
delib.module {
    name = "programs.hyprqt6engine";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username};
    in {
        home.packages = [
            inputs.hyprqt6engine.packages.${pkgs.stdenv.hostPlatform.system}.hyprqt6engine
        ];
        xdg.configFile."hypr/hyprqt6engine.conf".text = inputs.home-manager.lib.hm.generators.toHyprconf {
            attrs.theme = {
                color_scheme = "${home.xdg.stateHome}/rong/qtct.colors";
                font_fixed = "JetbrainsMono Nerd Font";
                font_fixed_size = 10;
                font = "Noto Sans";
                font_size = 10;
            };
        };
    };
}
