{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "ffscale";
  completion = {
    inherit name;
    flags = {
      "-c, --scale" = "Scale multiplier (e.g. 2, 1.5, 0.5)";
      "-q, --quality" = "Target height (e.g. 1080, 720)";
      "-s, --size" = "Explicit scale string (e.g. 1920:1080)";
      "-f, --filter" = "Explicit scale string (e.g. fps=10)";
    };
    completion.positionalany = [ "$files" ];
  };
  package = pkgs.buildGoModule {
    inherit name;
    src = ./.;
    vendorHash = "sha256-Z8V1a3uJdG/lj6AP4Xly01MQSq/yBnB2/TuERrrj0o0=";
    subPackages = [ ];
  };
}
