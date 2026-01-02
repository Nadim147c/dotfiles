{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "system-usages";
  partof = "programs.quickshell";
  package = pkgs.buildGoModule {
    pname = name;
    version = "0.0.1";
    src = ./.;
    vendorHash = "sha256-vVty21FA1+TOohviLz3ZTjDtxplO+NSerb14AvYbABA=";
    subPackages = [ ];
  };
}
