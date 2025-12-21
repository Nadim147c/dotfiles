{
  delib,
  constants,
  ...
}:
let
  inherit (constants) username;
in
delib.module {
  name = "home";

  home.always.home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
