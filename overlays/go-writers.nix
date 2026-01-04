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
          cgo ? false,
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
          finalShellArgs = unique finalArgs |> escapeShellArgs;
        in
        prev.writers.makeBinWriter {
          compileScript = /* bash */ ''
            cp "$contentPath" tmp.go
            export HOME=$NIX_BUILD_TOP/.home
            CGO_ENABLED=${if cgo then "1" else "0"} ${go}/bin/go build ${finalShellArgs} ${ldflagsString} -o "$out" tmp.go
          '';
        } name;

      writeGoBin = name: writeGo "/bin/${name}";
    };
  };
}
