{
    config,
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.rust";

    options = delib.singleEnableOption true;

    home.ifEnabled = {myconfig, ...}: let
        inherit (myconfig.constants) username;
        xdg = config.home-manager.users.${username}.xdg;
    in {
        home.sessionVariables = {
            CARGO_HOME = "${xdg.dataHome}/cargo";
            RUSTUP_HOME = "${xdg.dataHome}/rustup";
            RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
        };
        home.packages = with pkgs; [
            cargo
            rust-analyzer
            clippy
            rustfmt
            cargo-edit
            cargo-watch
            cargo-audit
            cargo-outdated
        ];
    };
}
