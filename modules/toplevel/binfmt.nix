{
  delib,
  host,
  ...
}:
delib.module {
  name = "binfmt";
  options = delib.singleEnableOption host.devFeatured;
  nixos.ifEnabled.boot.binfmt.emulatedSystems = [
    "wasm32-wasi"
    "x86_64-windows"
    "aarch64-linux"
  ];
}
