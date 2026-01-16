{
  delib,
  host,
  pkgs,
  ...
}:
let
  statix = pkgs.statix.overrideAttrs (_: rec {
    src = pkgs.fetchFromGitHub {
      owner = "oppiliappan";
      repo = "statix";
      rev = "43681f0da4bf1cc6ecd487ef0a5c6ad72e3397c7";
      hash = "sha256-LXvbkO/H+xscQsyHIo/QbNPw2EKqheuNjphdLfIZUv4=";
    };

    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = src + "/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
  });
in
delib.module {
  name = "dev.nix";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    nix-update
    nixd
    nixfmt
    statix
  ];
}
