{
    delib,
    pkgs,
    host,
    ...
}:
delib.module {
    name = "programs.obs-studio";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled.programs.obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
            obs-gstreamer
            obs-pipewire-audio-capture
            obs-vaapi
            wlrobs
        ];
    };
}
