{ delib, ... }:
delib.overlayModule {
  name = "go-writers";
  overlay = final: prev: {
    writers = prev.writers // rec {
      writeGo =
        name:
        {
          go ? prev.go,
          goArgs ? [ ],
          ldflags ? [ ],
          strip ? true,
          trimpath ? true,
        }:
        let
          inherit (prev.lib)
            escapeShellArgs
            optional
            optionalString
            unique
            ;

          hasElem = l: (builtins.length l) > 0;

          stripLdflags = optional strip [
            "-s"
            "-w"
          ];

          finalLdflags = ldflags ++ stripLdflags |> unique;
          ldflagsString = optionalString (hasElem finalLdflags) "-ldflags=${escapeShellArgs finalLdflags}";

          finalArgs = goArgs ++ optional trimpath [ "-trimpath" ];
        in
        prev.writers.makeBinWriter {
          compileScript = /* bash */ ''
            cp "$contentPath" tmp.go
            export HOME=$NIX_BUILD_TOP/.home
            ${go}/bin/go build ${unique finalArgs |> escapeShellArgs} ${ldflagsString} -o "$out" tmp.go
          '';
        } name;

      writeGoBin = name: writeGo "/bin/${name}";
    };
  };
}
