{
    config,
    delib,
    host,
    inputs,
    lib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.spotify";

    options = delib.singleEnableOption host.isDesktop;

    nixos.ifEnabled.services.flatpak.packages = ["com.spotify.Client"];
    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        home = config.home-manager.users.${username};
    in {
        home.packages = [pkgs.spicetify-cli];
        xdg.configFile."spicetify/Themes/Sleek/user.css".source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/spicetify/spicetify-themes/refs/heads/master/Sleek/user.css";
            sha256 = "19qxwzgvrvpqa400ydlmp12l2v3a330splbh8n8mj8fiiqj7liz4";
        };

        home.activation.configureSpicetify = let
            cli = "${lib.getExe pkgs.spicetify-cli}";
        in
            inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
                ${cli} config spotify_path         /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/
                ${cli} config prefs_path           ${home.xdg.configHome}/spotify/prefs
                ${cli} config current_theme        Sleek
                ${cli} config color_scheme         rong
                ${cli} config sidebar_config       0
                ${cli} config spotify_launch_flags '--enable-features=WaylandWindowDecorations --ozone-platform-hint=auto'
                ${cli} apply || true
            '';
    };
}
