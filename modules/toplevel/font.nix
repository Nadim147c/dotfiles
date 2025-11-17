{
    delib,
    lib,
    pkgs,
    ...
}:
delib.module {
    name = "font";

    options = delib.moduleOptions (with delib; {
        enable = boolOption true;
        sans = strOption "Roboto";
        serif = strOption "Roboto Serif";
        mono = strOption "JetBrainsMono Nerd Font";
        size = intOption 10;
        packages = listOfOption package (with pkgs; [
            electroharmonix
            fontconfig
            nerd-fonts.jetbrains-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-emoji
            noto-fonts-extra
            roboto
            roboto-flex
            roboto-mono
            roboto-serif
            roboto-slab
        ]);
    });

    home.ifEnabled = {cfg, ...}: {
        home.packages = cfg.packages;
        fonts.fontconfig = {
            enable = true;
            defaultFonts = {
                sansSerif = lib.lists.unique [
                    cfg.sans
                    "Roboto"
                    "Noto Sans"
                    "Noto Sans Bengali"
                ];

                monospace = lib.lists.unique [
                    cfg.mono
                    "JetBrainsMono Nerd Font"
                    "Roboto Mono"
                    "monospace"
                ];

                serif = lib.lists.unique [
                    cfg.serif
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
