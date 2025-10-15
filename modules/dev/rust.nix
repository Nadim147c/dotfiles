{
    delib,
    host,
    pkgs,
    xdg,
    ...
}:
delib.module {
    name = "dev.rust";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled = {
        home.sessionVariables = {
            CARGO_HOME = "${xdg.dataHome}/cargo";
            RUSTUP_HOME = "${xdg.dataHome}/rustup";
            RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
        };
        home.packages = with pkgs; [
            cargo
            cargo-audit
            cargo-edit
            cargo-outdated
            cargo-watch
            clippy
            rust-analyzer
            rustfmt
        ];
    };
}
