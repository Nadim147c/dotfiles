{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "setup.font";

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

            electroharmonix
        ];

        fonts.fontconfig = {
            enable = true;

            defaultFonts = {
                sansSerif = [
                    "Noto Sans"
                    "Noto Sans Bengali"
                ];

                monospace = [
                    "JetBrainsMono Nerd Font"
                    "monospace"
                ];

                serif = [
                    "Noto Serif"
                    "Noto Serif Bengali"
                ];

                emoji = [
                    "Noto Color Emoji"
                    "Twemoji"
                ];
            };
        };
    };
}
