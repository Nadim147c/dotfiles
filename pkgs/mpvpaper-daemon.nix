{
    buildGoModule,
    lib,
    ...
}:
buildGoModule {
    pname = "mpvpaper-daemon";
    version = "0.0.1";

    src = ./src/mpvpaper-daemon;

    vendorHash = "sha256-qWQM+DlW/9/JlAv9M7QBUch3wSeOQFVgGxmkIm29yAM=";

    subPackages = [];

    meta = {
        description = "A output colorizer for your favorite commands";
        homepage = "https://github.com/Nadim147c/ChromaShift";
        license = lib.licenses.gpl3Only;
        mainProgram = "mpvpaper-daemon";
    };
}
