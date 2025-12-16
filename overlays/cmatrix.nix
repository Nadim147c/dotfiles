{ delib, ... }:
delib.overlayModule {
  name = "cmatrix";
  overlay = final: prev: {
    cmatrix = prev.cmatrix.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -DHAVE_USE_DEFAULT_COLORS";
    });
  };
}
