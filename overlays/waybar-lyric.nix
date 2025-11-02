{delib, ...}:
delib.overlayModule {
    name = "waybar-lyric";
    overlay = final: prev: {
        waybar-lyric = prev.waybar-lyric.overrideAttrs (old: {
            ldflags = old.ldflags ++ ["-s" "-w" "-X main.Version=${old.version}"];
            nativeBuildInputs = old.nativeBuildInputs ++ [prev.installShellFiles];
            postInstall = prev.lib.optionalString (prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform) # bash

            ''
                installShellCompletion --cmd waybar-lyric \
                  --bash <($out/bin/waybar-lyric _carapace bash) \
                  --fish <($out/bin/waybar-lyric _carapace fish) \
                  --zsh <($out/bin/waybar-lyric _carapace zsh)
            '';
        });
    };
}
