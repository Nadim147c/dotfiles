{
  delib,
  host,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "dev.go";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled = {
    home.packages = with pkgs; [
      gofumpt
      gopls
      gopls
      golines
      revive
    ];
    home.sessionVariables = {
      GOMODCACHE = "${xdg.cacheHome}/go/mod";
      GOBIN = "${xdg.dataHome}/go/bin";
      GOPATH = "${xdg.dataHome}/go";
      CGO_ENABLED = "0";
    };
    programs.go = {
      enable = true;
      telemetry.mode = "off";
      env = {
        GOPATH = "${xdg.dataHome}/go";
        GOBIN = "${xdg.dataHome}/go/bin";
      };
    };
  };
}
