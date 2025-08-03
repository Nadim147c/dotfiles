{pkgs, ...}: let
    ef = ../static/electron-flags.conf;
in {
    imports = [
        ./mpv.nix
        ./mime.nix
        ./yt-dlp.nix
    ];

    services.kdeconnect = {
        enable = true;
        indicator = true;
    };

    xdg.configFile = {
        "electron-flags.conf".source = ef;
        "equibop-flags.conf".source = ef;
        "spotify-flags.conf".source = ef;
    };

    home.file.".config/kitty" = {
        source = ../static/kitty;
        recursive = true;
    };
    home.packages = with pkgs; [
        # This kitty package doesn't work properly on non nixos distro
        # kitty
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-emoji-blob-bin
        noto-fonts-color-emoji
        dunst
    ];
}
