{
  delib,
  host,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "dev.javascript";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled = {
    home.packages = with pkgs; [
      bun
      deno
      eslint
      nodejs
      pnpm
      prettier
      prettierd
      typescript
      typescript-language-server
      yarn
    ];

    home.sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${xdg.configHome}/npm/npmrc";
      PNPM_HOME = "${xdg.dataHome}/pnpm";
    };

    xdg.configFile."npm/npmrc".text = ''
      prefix=${xdg.dataHome}/npm
      cache=${xdg.cacheHome}/npm
      init-module=${xdg.configHome}/npm/config/npm-init.js
      logs-dir=${xdg.stateHome}/npm/logs
      color=true
    '';
  };
}
