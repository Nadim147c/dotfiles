{ delib, ... }:
delib.overlayModule {
  name = "nixos-bgrt-plymouth";
  overlay = final: prev: {
    nixos-bgrt-plymouth = prev.nixos-bgrt-plymouth.overrideAttrs (old: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/plymouth/themes/nixos-bgrt
        cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/nixos-bgrt/
        substituteInPlace $out/share/plymouth/themes/nixos-bgrt/*.plymouth \
            --replace '@IMAGES@' "$out/share/plymouth/themes/nixos-bgrt/images" \
            --replace "Cantarell 20" "Cantarell 16"

        runHook postInstall
      '';
    });
  };
}
