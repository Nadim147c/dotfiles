{
    inputs,
    lib,
    home,
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "waybar-lyric";
    partof = "programs.quickshell";
    package = let
        localBin = "${home.home.homeDirectory}/.local/bin/waybar-lyric";
        system = pkgs.stdenv.hostPlatform.system;
        flakeBin = lib.getExe inputs.waybar-lyric.packages.${system}.default;
    in
        pkgs.writeShellScriptBin "waybar-lyric" ''
            if [ -f "${localBin}" ]; then
                exec -a "$0" "${localBin}" $@
            else
                exec -a "$0" "${flakeBin}" $@
            fi
        '';
}
