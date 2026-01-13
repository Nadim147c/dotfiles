{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "mpvpaper-daemon";
  partof = "programs.mpvpaper";
  package = pkgs.buildGoModule {
    inherit name;
    src = ./.;
    vendorHash = "sha256-jr8KbRsmm5cZv31nfkHBZVq0shw0jYj7FNymFRaFsfk=";
    subPackages = [ ];
  };
}
