{delib, ...}:
delib.module {
    name = "programs.hyprland";

    home.ifEnabled.wayland.windowManager.hyprland.settings = {
        animations = {
            enabled = true;

            bezier = [
                "wind,     0.05, 0.9,  0.1, 1.05"
                "winIn,    0.1,  1.1,  0.1, 1.1"
                "winOut,   0.3,  -0.3, 0,   1"
                "liner,    1,    1,    1,   1"
                "layer,    0.05, 0.9,  0.1, 1"
                "layerIn,  0.1,  1,    0.1, 1"
                "layerOut, 0.0,  0.9,  0.0, 0.9"
            ];

            animation = [
                "windows,     1, 5,  wind,   slide"
                "windowsIn,   1, 5,  winIn,  slide"
                "windowsOut,  1, 5,  winOut, slide"
                "windowsMove, 1, 5,  wind,   slide"
                "layers,      1, 5,  layer,  slide"
                "layersIn,    1, 5,  layerIn,  slide"
                "layersOut,   1, 5,  layerOut,  slide"
                "fade,        1, 10, default"
                "border,      0, 1,  liner"
                "fadeLayers,  1, 5,  default"
                "workspaces,  1, 5,  wind"
            ];
        };
    };
}
