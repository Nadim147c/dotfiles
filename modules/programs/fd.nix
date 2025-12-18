{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.fd";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      "*.bak"
    ];
  };
}
