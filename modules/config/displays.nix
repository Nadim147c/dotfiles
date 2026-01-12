{ delib, lib, ... }:
let
  inherit (lib) mapAttrsToList;
in
delib.module {
  name = "displays";

  options =
    { myconfig, ... }:
    {
      displays = delib.attrsOfSubmodule (with delib; {
        enable = boolOption true;
        primary = boolOption ((lib.attrValues myconfig.displays |> builtins.length) == 1);
        refreshRate = numberOption 60;
        scale = numberOption 1;
        touchscreen = boolOption false;
        width = intOption 1920;
        height = intOption 1080;
        x = intOption 0;
        y = intOption 0;
      }) { };
    };

  nixos.always =
    { cfg, ... }:
    {
      boot.kernelParams =
        let
          format = display: with display; "${toString width}x${toString height}@${toString refreshRate}";
          mkFlag = name: display: "video=${name}:${if display.enable then format display else "d"}";
        in
        mapAttrsToList mkFlag cfg;
    };
}
