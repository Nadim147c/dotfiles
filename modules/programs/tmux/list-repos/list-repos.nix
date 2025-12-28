{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "list-repos";
  partof = "programs.tmux";
  package = pkgs.buildGoModule {
    pname = name;
    version = "0.0.1";
    src = ./.;
    vendorHash = "sha256-ttK0PPLIo8N5VhINhMQAjn43hjNTwOik11zMcA6Hios=";
    subPackages = [ ];
  };
}
