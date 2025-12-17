{
  inputs,
  delib,
  host,
  xdg,
  ...
}:
delib.module {
  name = "programs.rong";

  options = delib.singleEnableOption host.isDesktop;

  home.always.imports = [ inputs.rong.homeModules.default ];

  # Redirect
  home.ifEnabled.xdg.configFile = {
    "gtk-4.0/gtk.css".target = "gtk-4.0/gtk.css.ignored";
  };

  home.ifEnabled.programs.rong = {
    enable = true;
    settings = {
      dark = true;
      preview-format = "jpg";
      base16 = {
        blend = 0.5;
        method = "static";
      };
      material = {
        contrast = 0.0;
        platform = "phone";
        variant = "expressive";
        version = "2025";
        custom = {
          blend = true;
          colors = {
            purple = "#800080";
            orange = "#FFA500";
          };
        };
      };
      links =
        let
          config = path: "${xdg.configHome}/${path}";
          data = path: "${xdg.dataHome}/${path}";
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
