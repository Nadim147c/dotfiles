{
  compile-scss,
  coreutils,
  fd,
  gawk,
  gum,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "wallpaper.sh";
  runtimeInputs = [
    compile-scss
    coreutils
    fd
    gawk
    gum
  ];

  text = builtins.readFile ../src/wallpaper.sh;
}
