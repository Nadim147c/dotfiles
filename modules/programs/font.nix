{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "font";

    options = delib.singleEnableOption host.isDesktop;

    home.ifEnabled = {
        home.packages = with pkgs; [
            # Noto Sans Fonts
            noto-fonts
            noto-fonts-emoji
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-extra

            # JetBrainsMono Nerd Font
            fontconfig
            nerd-fonts.jetbrains-mono
        ];

        fonts.fontconfig = {
            enable = true;

            defaultFonts = {
                sansSerif = [
                    "Noto Sans"
                    "Noto Sans Mono"
                ];

                monospace = ["JetBrainsMono Nerd Font"];

                serif = ["Noto Serif"];

                emoji = [
                    "Noto Color Emoji"
                    "Twemoji"
                ];
            };
        };
    };
}
