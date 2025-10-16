{
    delib,
    inputs,
    ...
}:
delib.module {
    name = "catppuccin";

    options = delib.singleEnableOption true;

    home.always.imports = [inputs.catppuccin.homeModules.catppuccin];
    nixos.always.imports = [inputs.catppuccin.nixosModules.catppuccin];

    home.ifEnabled.catppuccin = let
        enabled = {
            enable = true;
            flavor = "mocha";
        };
    in {
        kitty = enabled;
        fzf = enabled;
        btop = enabled;
    };
}
