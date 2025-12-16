{ delib, ... }:
delib.module {
  name = "programs.tldr";

  options = delib.singleEnableOption true;

  home.ifEnabled.programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
    settings.updates = {
      auto_update = true;
      auto_update_interval_hours = 100;
    };
  };
}
