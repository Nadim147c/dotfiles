{ delib, ... }:
delib.overlayModule {
  name = "write-nu-application";
  overlay = final: prev: {
    writeNuApplication =
      {
        name,
        runtimeInputs ? [ ],
        text,
      }:
      let
        PATH = map (x: "${x}/bin") runtimeInputs |> prev.lib.escapeShellArgs;
      in
      prev.writers.writeNuBin name ''
        ${prev.lib.optionalString (PATH != "") /* nu */ "$env.PATH = [ ${PATH} ] ++ $env.PATH"}

        ${text}
      '';
  };
}
