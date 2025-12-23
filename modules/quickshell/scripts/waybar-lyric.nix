{
  delib,
  pkgs,
  func,
  ...
}:
let
  localBin = func.xdg.bin "waybar-lyric";
in
delib.script {
  name = "waybar-lyric";
  partof = "programs.quickshell";
  package = pkgs.writeShellScriptBin "waybar-lyric" ''
    if [ -f "${localBin}" ]; then
        exec -a "$0" "${localBin}" $@
    else
        exec -a "$0" ${pkgs.waybar-lyric}/bin/waybar-lyric $@
    fi
  '';
}
