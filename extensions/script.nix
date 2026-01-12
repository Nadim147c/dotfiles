{
  lib,
  delib,
  ...
}:
let
  inherit (delib) extension singleEnableOption;
  inherit (lib) mkIf;
in
extension {
  name = "script";
  description = "Simplified script module";

  libExtension = config: final: _: {
    script =
      {
        name,
        partof ? "",
        targets ? [ "home" ],
        completion ? null,
        enable ? true,
        package ? null,
      }:
      final.module {
        name = if partof != "" then partof else "scripts.${name}";

        options =
          if partof != "" then
            delib.moduleOptions { scripts.${name} = delib.boolOption enable; }
          else
            singleEnableOption enable;

        nixos.ifEnabled =
          { cfg, ... }:
          let
            enabled = if partof != "" then cfg.scripts.${name} else cfg.enable;
          in
          mkIf (enabled && lib.elem "nixos" targets) {
            environment.systemPackages = [ package ];
          };

        home.ifEnabled =
          { cfg, ... }:
          let
            enabled = if partof != "" then cfg.scripts.${name} else cfg.enable;
          in
          mkIf (enabled && lib.elem "home" targets) {
            home.packages = [ package ];
          };

        myconfig.ifEnabled = mkIf (completion != null && completion != { }) {
          programs.carapace.custom."${name}" = completion;
        };
      };
  };
}
