{ buildGoModule, ... }:
buildGoModule {
  pname = "mpvpaper-daemon";
  version = "0.0.1";
  src = ../src/mpvpaper-daemon;
  vendorHash = "sha256-qWQM+DlW/9/JlAv9M7QBUch3wSeOQFVgGxmkIm29yAM=";
  subPackages = [ ];
}
