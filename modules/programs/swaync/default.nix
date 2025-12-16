{
  delib,
  inputs,
  pkgs,
  host,
  xdg,
  ...
}:
delib.module {
  name = "programs.swaync";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.activation.compileSwayncSyle =
      inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
        /* bash */ ''
          ${pkgs.coreutils}/bin/install -Dm644 ${./style.scss} ${xdg.configHome}/swaync/style.scss
          ${pkgs.compile-scss}/bin/compile-scss ${xdg.configHome}/swaync/style.scss
        '';

    services.swaync.enable = true;
  };
}
