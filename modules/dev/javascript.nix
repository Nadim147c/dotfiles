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
        home.sessionVariables = {
            NPM_CONFIG_USERCONFIG = "${xdg.configHome}/npm/npmrc";
            PNPM_HOME = "${xdg.dataHome}/pnpm";
        };
        home.packages = with pkgs; [
            bun
            deno
            eslint
            nodejs
            pnpm
            prettier
            prettierd
            typescript
            yarn
        ];
    };
}
