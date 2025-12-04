{
    inputs,
    delib,
    host,
    pkgs,
    home,
    ...
}:
delib.module {
    name = "programs.yankd";

    options = delib.singleEnableOption host.guiFeatured;

    home.always.imports = [inputs.yankd.homeModules.default];
    home.ifEnabled.services.yankd = {
        enable = true;
        # impure type shi...
        package = let
            localBin = "${home.home.homeDirectory}/.local/bin/yankd";
            system = pkgs.stdenv.hostPlatform.system;
            flakeBin = "${inputs.yankd.packages.${system}.default}/bin/yankd";
        in
            pkgs.writeShellScriptBin "yankd" ''
                if [ -f "${localBin}" ]; then
                    exec -a "$0" "${localBin}" $@
                else
                    exec -a "$0" "${flakeBin}" $@
                fi
            '';
        systemdTargets = ["wayland-session@Hyprland.target"];
    };
}
