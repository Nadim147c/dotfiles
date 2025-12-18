{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.ripgrep";
  options = delib.singleEnableOption host.cliFeatured;
  home.ifEnabled.programs.ripgrep = {
    enable = true;
    arguments = [
      "--hidden"
      "--glob=!.git/*"
    ];
  };
}
