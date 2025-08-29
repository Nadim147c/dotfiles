{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.alacritty";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) shell;
    in {
        programs.alacritty = {
            enable = true;
            # This alacritty package doesn't work properly on non nixos distro
            package = null;
            settings = {
                general.live_config_reload = true;
                window = {
                    padding.x = 4;
                    padding.y = 4;
                };
                font = {
                    size = 9.5;
                    normal.family = "JetbrainsMono Nerd Font";
                    package = pkgs.nerd-fonts.jetbrains-mono;
                };
                termial = {
                    shell = shell;
                    osc52 = "CopyPaste";
                };
            };
        };
    };
}
