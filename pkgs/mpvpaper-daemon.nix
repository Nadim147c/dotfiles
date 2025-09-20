{
    buildGoModule,
    lib,
    ...
}:
buildGoModule {
    pname = "mpvpaper-daemon";
    version = "0.0.1";

    src = ./src/mpvpaper-daemon;

    vendorHash = "sha256-uX+yvAalg7tcwO0yl09kFOK0eHDAtf5JtTiami+o2m0=";

    subPackages = [];

    meta = {
        description = "A output colorizer for your favorite commands";
        homepage = "https://github.com/Nadim147c/ChromaShift";
        license = lib.licenses.gpl3Only;
        mainProgram = "mpvpaper-daemon";
    };
}
