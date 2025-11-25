{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.bat";

    options = delib.singleEnableOption host.cliFeatured;

    home.ifEnabled.home.sessionVariables.MANPAGER = "bat -plman";

    home.ifEnabled.programs.bat = {
        enable = true;
        config = {
            pager = "${pkgs.less}/bin/less -rF";
            theme = "ansi";
        };
        extraPackages = with pkgs.bat-extras; [
            batman
            batgrep
        ];
    };
}
