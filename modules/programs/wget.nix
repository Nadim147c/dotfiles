{
    delib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.wget";

    options = delib.singleEnableOption true;

    home.ifEnabled = {
        home.packages = [pkgs.wget];
        home.sessionVariables.WGETRC = "${xdg.configHome}/wget/config";
        xdg.configFile."wget/config".text = ''
            hsts-file = ${xdg.cacheHome}/wget-hsts
        '';
    };
}
