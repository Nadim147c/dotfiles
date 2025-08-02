{pkgs, ...}: {
    imports = [
        ./programs/mpv.nix
        ./programs/alacritty.nix
        ./programs/mime.nix
    ];

    services.kdeconnect = {
        enable = true;
        indicator = true;
    };

    home.file.".config/kitty" = {
        source = ../config/kitty;
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
