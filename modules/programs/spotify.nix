{
    delib,
    host,
    inputs,
    lib,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "programs.spotify";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled.services.flatpak.packages = ["com.spotify.Client"];
    home.ifEnabled = {
        home.packages = [pkgs.spicetify-cli];
        xdg.configFile."spicetify/Themes/Sleek/user.css".source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/spicetify/spicetify-themes/refs/heads/master/Sleek/user.css";
            sha256 = "19qxwzgvrvpqa400ydlmp12l2v3a330splbh8n8mj8fiiqj7liz4";
        };

        home.activation.configureSpicetify = let
            cli = "${lib.getExe pkgs.spicetify-cli}";
            cfgFile = "${xdg.configHome}/spicetify/config-xpui.ini";
            ini = "${lib.getExe pkgs.crudini} --set ${cfgFile}";
        in
            inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] # bash

            ''
                ${cli} apply || true

                mkdir -p $(dirname ${cfgFile})
                ${ini} Setting color_scheme  rong
                ${ini} Setting current_theme Sleek
                ${ini} Setting prefs_path    "$HOME/.var/app/com.spotify.Client/config/spotify/prefs"
                ${ini} Setting spotify_path  /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify

                # For wayland
                ${ini} Setting spotify_launch_flags ' --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto'

                ${ini} AdditionalOptions sidebar_config 0

                ${cli} apply || true
            '';
    };
}
