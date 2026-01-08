{
  inputs,
  delib,
  host,
  func,
  ...
}:
delib.module {
  name = "programs.yankd";

  options = delib.singleEnableOption host.guiFeatured;

  home.always.imports = [ inputs.yankd.homeModules.default ];
  home.ifEnabled.services.yankd = {
    enable = true;
    package = func.flakePackage inputs.yankd |> func.wrapLocal;
  };
}
