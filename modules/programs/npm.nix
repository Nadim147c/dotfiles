{
    delib,
    host,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.npm";

    options = delib.singleEnableOption (host.cliFeatured && host.devFeatured);

    home.ifEnabled = {
        home.packages = with pkgs; [nodejs];
        xdg.configFile."npm/npmrc".text = ''
            prefix=${xdg.dataHome}/npm
            cache=${xdg.cacheHome}/npm
            init-module=${xdg.configHome}/npm/config/npm-init.js
            logs-dir=${xdg.stateHome}/npm/logs
            color=true
        '';
    };
}
