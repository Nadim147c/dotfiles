{
    compile-scss,
    coreutils,
    crudini,
    dunst,
    fd,
    fork,
    gawk,
    gnugrep,
    gum,
    hyprland,
    killall,
    procps,
    writeShellApplication,
    ...
}:
writeShellApplication {
    name = "wallpaper.sh";
    runtimeInputs = [
        compile-scss
        coreutils
        crudini
        dunst
        fd
        fork
        gawk
        gnugrep
        gum
        hyprland
        killall
        procps
    ];

    text = builtins.readFile ../src/wallpaper.sh;
}
