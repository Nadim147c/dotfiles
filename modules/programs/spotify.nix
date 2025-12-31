{
  delib,
  homedir,
  host,
  inputs,
  pkgs,
  xdg,
  func,
  ...
}:
delib.module {
  name = "programs.spotify";

  options = delib.singleEnableOption host.isDesktop;

  nixos.ifEnabled.services.flatpak.packages = [ "com.spotify.Client" ];
  home.ifEnabled = {
    home.packages = [ pkgs.spicetify-cli ];

    programs.rong.settings.themes = func.mkList {
      target = "spicetify-sleek.ini";
      links = "${xdg.configHome}/spicetify/Themes/Sleek/color.ini";
      cmds = /* bash */ ''
        spicetify watch -s 2>&1 | sed '/Reloaded Spotify/q'
      '';
    };

    xdg.configFile."spicetify/Themes/Sleek/user.css".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/spicetify/spicetify-themes/43742241561b00dcf9b261827c43fd2c1073c857/Sleek/user.css";
      sha256 = "19qxwzgvrvpqa400ydlmp12l2v3a330splbh8n8mj8fiiqj7liz4";
    };

    # sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
    # sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps
    home.activation.configureSpicetify =
      let
        cfgFile = "${xdg.configHome}/spicetify/config-xpui.ini";
        config = pkgs.writeText "spicetify-config" /* ini */ ''
          [Setting]
          always_enable_devtools = 0
          check_spicetify_update = 0
          color_scheme           = rong
          current_theme          = Sleek
          inject_css             = 1
          inject_theme_js        = 1
          overwrite_assets       = 1
          prefs_path             = ${homedir}/.var/app/com.spotify.Client/config/spotify/prefs
          replace_colors         = 1
          spotify_launch_flags   = --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto
          spotify_path           = /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify

        '';
      in
      inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
        install -Dm644 ${config} ${cfgFile} || true
      '';
  };
}
