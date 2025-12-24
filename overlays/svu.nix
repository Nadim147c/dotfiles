{ delib, ... }:
delib.overlayModule {
  name = "svu";
  overlay = final: prev: {
    svu = prev.svu.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ prev.installShellFiles ];
      postInstall =
        let
          canExecute = prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform;
        in
        prev.lib.optionalString canExecute /* bash */ ''
          installShellCompletion --cmd svu \
            --bash <($out/bin/svu completion bash) \
            --fish <($out/bin/svu completion fish) \
            --zsh <($out/bin/svu completion zsh)
        '';
    });
  };
}
