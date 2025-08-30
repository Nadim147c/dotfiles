{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "programs.plymouth";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled.boot.plymouth = {
        enable = true;
        font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
        theme = "connect";
        themePackages = [pkgs.adi1090x-plymouth-themes];
    };
}
