{
  delib,
  host,
  pkgs,
  xdg,
  ...
}:
delib.module {
  name = "programs.freeze";
  # Screenshot tool only makes sense in personal computer
  options = delib.singleEnableOption host.isPC;

  home.ifEnabled.home.packages =
    let
      pkg = pkgs.writeShellScriptBin "freeze" ''
        exec -a "$0" ${pkgs.charm-freeze}/bin/freeze \
            --output ${xdg.userDirs.pictures}/"freeze-$(date +'%Y-%m-%d_%H-%M-%S').png" "$@"
      '';
    in
    [ pkg ];
}
