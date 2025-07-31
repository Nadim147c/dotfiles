{pkgs, ...}: {
    imports = [
        ./programs/mpv.nix
        ./programs/alacritty.nix
        ./programs/mime.nix
    ];

    home.file.".config/kitty" = {
        source = ../config/kitty;
        recursive = true;
    };
    home.packages = with pkgs; [
        # This kitty package doesn't work properly on non nixos distro
        # kitty
        nerd-fonts.jetbrains-mono
    ];
}
