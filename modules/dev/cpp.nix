{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "dev.cpp";

    options = delib.singleEnableOption host.devFeatured;

    home.ifEnabled.home.packages = with pkgs; [
        bear
        ccache
        clang-tools
        cmake
        gcc
        gdb
        lldb
        ninja
        pkg-config
        valgrind
    ];
}
