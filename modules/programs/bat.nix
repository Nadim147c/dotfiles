{
    delib,
    host,
    ...
}:
delib.module {
    name = "programs.bat";
    options = delib.singleEnableOption host.cliFeatured;
    home.ifEnabled.programs.bat.enable = true;
}
