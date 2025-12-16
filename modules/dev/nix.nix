{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "dev.nix";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    nix-update
    nixd
    nixfmt-rfc-style
  ];
}
