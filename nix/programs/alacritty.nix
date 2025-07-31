{pkgs, ...}: {
    programs.alacritty = {
        enable = true;
        # This alacritty package doesn't work properly on non nixos distro
        package = null;
        settings = {
            general.live_config_reload = true;
            history = 10000;
            window = {
                padding.x = 4;
                padding.y = 4;
            };
            font = {
                size = 9.5;
                normal.family = "JetbrainsMono Nerd Font";
            };
            termial = {
                shell = "${pkgs.fish}/bin/fish";
                osc52 = "CopyPaste";
            };
            keyboard.binding = [
                {
                    key = "v";
                    mods = "Control";
                    action = "Paste";
                }
            ];
        };
    };
}
