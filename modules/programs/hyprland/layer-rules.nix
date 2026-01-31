{
  delib,
  lib,
  ...
}:
let
  inherit (lib) join toList;
in
delib.module {
  name = "programs.hyprland";

  home.ifEnabled =
    let
      createLayerRule =
        name: rules: namespaces:
        let
          identifier = {
            name = "${builtins.hashString "md5" (builtins.toJSON rules)}-${name}";
            "match:namespace" = "^(${join "|" namespaces})$";
          };
        in
        toList (rules // identifier);

      staticLayer = createLayerRule "static" {
        no_anim = true;
      };
      blurredLayer = createLayerRule "blurred" {
        blur = true;
        ignore_alpha = 0.5;
      };
    in
    {
      wayland.windowManager.hyprland.settings.layerrule =
        staticLayer [
          "selection"
          "hyprpicker"
          "mpvpaper"
        ]
        ++ blurredLayer [
          "wofi"
          "quickshell:bar"
          "quickshell:year"
          "quickshell:player"
          "quickshell:wallpaper"
        ];
    };
}
