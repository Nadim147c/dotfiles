{
  delib,
  host,
  ...
}:
delib.module {
  name = "bluetooth";

  options.bluetooth = with delib; {
    enable = boolOption host.wirelessFeatured;
    enableMprisProxy = boolOption true;
  };

  nixos.ifEnabled = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    services.blueman.enable = true;
  };

  home.ifEnabled =
    { cfg, ... }:
    {
      services.mpris-proxy.enable = cfg.enableMprisProxy;
      services.blueman-applet.enable = true;
    };
}
