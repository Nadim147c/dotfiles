{
  delib,
  pkgs,
  lib,
  ...
}:
delib.script {
  name = "compile-scss";
  package = pkgs.writeShellScriptBin "compile-scss" ''
    input="$1"
    output=$(echo "$input" | sed 's/scss$/css/')
    ${lib.getExe pkgs.dart-sass} --no-source-map "$input:$output"
  '';
}
