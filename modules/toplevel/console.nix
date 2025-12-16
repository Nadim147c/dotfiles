{ delib, ... }:
delib.module {
  name = "console";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.console = {
    enable = true;
    colors = [
      "000000"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "a6adc8"
      "000000"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "bac2de"
    ];
  };
}
