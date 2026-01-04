{
  delib,
  ...
}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled =
    let
      createMatch = x: {
        name = x;
        "match:namespace" = x;
      };
      createLayerRule = rules: namespaces: map (x: rules // (createMatch x)) namespaces;
      blurredLayer = createLayerRule {
        blur = true;
        ignore_alpha = 0.5;
      };
    in
    {
      wayland.windowManager.hyprland.settings.layerrule =
        createLayerRule { no_anim = true; } [
          "selection"
          "hyprpicker"
          "mpvpaper"
        ]
        ++ blurredLayer [
          "wofi"
          "quickshell:bar"
          "quickshell:player"
          "quickshell:wallpaper"
        ];
    };
}
