{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.python";

    options = delib.singleEnableOption true;

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
