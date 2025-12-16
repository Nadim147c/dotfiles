{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.udisks2";
  options = delib.singleEnableOption host.isPC;
  nixos.ifEnabled.services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };
}
