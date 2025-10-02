{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "dev.python";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = with pkgs; [
        black
        isort
        mypy
        pipx
        poetry
        pyright
        python3
        ruff
        uv
    ];
}
