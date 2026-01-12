{
  delib,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) attrsToList;
in
delib.module {
  name = "programs.carapace";

  options.programs.carapace = with delib; {
    enable = boolOption true;
    custom = attrsOption { };
  };

  home.ifEnabled =
    { cfg, ... }:
    let
      createFile = x: {
        name = "carapace/specs/${x.name}.yaml";
        value.source = pkgs.writers.writeYAML "${x.name}.yaml" x.value;
      };
    in
    {
      xdg.configFile =
        attrsToList cfg.custom
        |> builtins.filter (x: x.value != null && x.value != { })
        |> map createFile
        |> builtins.listToAttrs;
      home.sessionVariables = {
        CARAPACE_BRIDGES = "carapace,zsh,fish,bash";
      };
      programs.carapace = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };
}
