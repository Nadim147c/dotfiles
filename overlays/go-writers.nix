{ delib, ... }:
delib.overlayModule {
  name = "go-writers";
  overlay = final: prev: rec {
    writeGo =
      name:
      {
        makeWrapperArgs ? [ ],
        go ? prev.go,
        goArgs ? [ ],
        strip ? true,
      }:
      prev.writers.makeBinWriter {
        compileScript = ''
          cp "$contentPath" tmp.go
          export HOME=$NIX_BUILD_TOP/.home
          ${go}/bin/go build ${prev.lib.escapeShellArgs goArgs} -o "$out" tmp.go
        '';
        inherit makeWrapperArgs strip;
      } name;

    writeGoBin = name: writeGo "/bin/${name}";
  };
}
