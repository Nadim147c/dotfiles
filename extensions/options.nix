{
  lib,
  delib,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.types) submodule;
in
delib.extension {
  name = "options";
  libExtension = config: final: prev: {
    attrsOption =
      default:
      mkOption {
        inherit default;
        type = types.attrs;
      };
    attrsOfSubmodule =
      options: default:
      let
        type = submodule { inherit options; };
      in
      mkOption {
        type = types.attrsOf type;
        inherit default;
      };
    listOfSubmodule =
      options: default:
      let
        type = submodule { inherit options; };
      in
      mkOption {
        type = types.listOf type;
        inherit default;
      };
  };
}
