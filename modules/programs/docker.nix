{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.docker";

  options = delib.singleEnableOption (host.isServer || host.devFeatured);

  nixos.ifEnabled.virtualisation.docker.enable = true;
}
