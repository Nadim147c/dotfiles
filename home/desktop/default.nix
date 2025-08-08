{pkgs, ...}: let
    electronWayland = ''
        --enable-features=WaylandWindowDecorations
        --ozone-platform-hint=auto
    '';
in {
    imports = [
        ./mpv.nix
        ./mime.nix
        ./yt-dlp.nix
    ];

    home.packages = with pkgs; [
        # This kitty package doesn't work properly on non nixos distro
        # kitty
        dunst
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-emoji-blob-bin
        noto-fonts-color-emoji
        noto-fonts-emoji
    ];

    fonts.fontconfig = {
        enable = true;
        defaultFonts = {
            sansSerif = ["Noto Sans"];
            monospace = ["JetBrainsMono Nerd Font" "monospace"];
            emoji = ["Noto Color Emoji" "Noto Emoji"];
        };
    };

    xdg.configFile = {
        "electron-flags.conf".text = electronWayland;
        "equibop-flags.conf".text = electronWayland;
        "spotify-flags.conf".text = electronWayland;
    };

    xdg.configFile."kitty" = {
        source = ../static/kitty;
        recursive = true;
    };
}
