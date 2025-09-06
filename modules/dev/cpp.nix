{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "dev.cpp";

    options = delib.singleEnableOption true;

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
