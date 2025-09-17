{
    buildGoModule,
    fetchFromGitHub,
    lib,
    ...
}:
buildGoModule rec {
    pname = "chromashift";
    version = "2.0.0";

    src = fetchFromGitHub {
        owner = "Nadim147c";
        repo = "ChromaShift";
        rev = "v${version}";
        hash = "sha256-Yndv1gdnVZqgpY9ai4UlLA54dsFAZxpUYDJpmOhKJis=";
    };

    vendorHash = "sha256-rPh8RRY4lm4z6ab4thyshy4ppgCLJB6zHhp5OR2nOt8=";

    ldflags = ["-s" "-w" "-X" "cshift/cmd.Version=${version}"];
    subPackages = [];

    meta = {
        description = "A output colorizer for your favorite commands";
        homepage = "https://github.com/Nadim147c/ChromaShift";
        license = lib.licenses.gpl3Only;
        mainProgram = "cshift";
    };
}
