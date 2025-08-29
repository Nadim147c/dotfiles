{
    config,
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.npm";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        xdg = config.home-manager.users.${username}.xdg;
    in {
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
