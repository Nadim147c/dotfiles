{
  delib,
  xdg,
  ...
}:
delib.module {
  name = "programs.bash";

  options = delib.singleEnableOption true;

  home.ifEnabled.programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = "${xdg.dataHome}/bash/history";
  };
}
