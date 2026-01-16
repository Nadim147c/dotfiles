{
  delib,
  func,
  host,
  inputs,
  xdg,
  ...
}:
delib.module {
  name = "programs.rong";

  options = delib.singleEnableOption host.isDesktop;

  home.always.imports = [ inputs.rong.homeModules.default ];

  home.ifEnabled.programs.rong = {
    enable = true;
    package = func.flakePackage inputs.rong |> func.wrapLocal;
    settings = {
      dark = true;
      preview-format = "jpg";
      base16 = {
        blend = 0.5;
        method = "dynamic";
      };
      material = {
        contrast = 0.0;
        platform = "phone";
        variant = "tonal_spot";
        version = "2025";
        custom = {
          blend = 0.5;
          colors = {
            purple = "#800080";
            orange = "#FFA500";
          };
        };
      };
      links =
        let
          config = p: "${xdg.configHome}/${p}";
          data = p: "${xdg.dataHome}/${p}";
        in
        {
          "qtct.colors" = data "color-schemes/Rong.colors";
          "qtct.conf" = [
            (config "qt5ct/colors/rong.conf")
            (config "qt6ct/colors/rong.conf")
          ];
          "gtk.css" = [
            (config "gtk-3.0/gtk.css")
            (config "gtk-4.0/gtk.css")
          ];
        };
    };
  };
}
