{
  coreutils,
  dart-sass,
  gum,
  inotify-tools,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "compile-scss";
  runtimeInputs = [
    dart-sass
    inotify-tools
    coreutils
    gum
  ];
  text = builtins.readFile ../src/compile-scss.sh;
}
