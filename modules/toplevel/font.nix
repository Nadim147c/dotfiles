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
            electroharmonix
            roboto
            roboto-flex
            roboto-mono
            roboto-serif
            roboto-slab
            fontconfig
            nerd-fonts.jetbrains-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-emoji
            noto-fonts-extra
        ];

        fonts.fontconfig = {
            enable = true;

            defaultFonts = {
                sansSerif = [
                    "Roboto"
                    "Noto Sans"
                    "Noto Sans Bengali"
                ];

                monospace = [
                    "JetBrainsMono Nerd Font"
                    "Roboto Mono"
                    "monospace"
                ];

                serif = [
                    "Roboto Serif"
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
