{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "constants";

    options.constants = with delib; {
        username = readOnly (strOption "ephemeral");
        userfullname = readOnly (strOption "Ephemeral");
        useremail = readOnly (strOption "theephemeral.txt@gmail.com");
        shell = readOnly (strOption "${pkgs.fish}/bin/fish");
    };
}
