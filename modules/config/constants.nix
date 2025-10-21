{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "constants";

    options.constants = with delib; {
        username = readOnly (strOption "ephemeral");
        fullname = readOnly (strOption "Ephemeral");
        email = readOnly (strOption "theephemeral.txt@gmail.com");
        shell = readOnly (strOption "${pkgs.fish}/bin/fish");
    };

    myconfig.always = {cfg, ...}: {
        args.shared.constants = cfg;
    };
}
