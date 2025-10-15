{
    delib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.npm";

    options = delib.singleEnableOption true;

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
