{ buildGoModule, ... }:
buildGoModule {
  pname = "mpvpaper-daemon";
  version = "0.0.1";
  src = ../src/mpvpaper-daemon;
  vendorHash = "sha256-jr8KbRsmm5cZv31nfkHBZVq0shw0jYj7FNymFRaFsfk=";
  subPackages = [ ];
}
