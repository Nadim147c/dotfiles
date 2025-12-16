{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "netspeed";
  partof = "programs.quickshell";
  package = pkgs.buildGoModule {
    pname = "netspeed";
    version = "0.0.1";
    src = ../../../src/netspeed;
    vendorHash = null;
    subPackages = [ ];
  };
}
