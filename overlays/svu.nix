{ delib, ... }:
delib.overlayModule {
  name = "svu";
  overlay = final: prev: {
    svu = prev.svu.overrideAttrs (old: rec {
      version = "3.3.0";

      src = prev.fetchFromGitHub {
        owner = "caarlos0";
        repo = "svu";
        rev = "v${version}";
        sha256 = "sha256-3Rj+2ROo9TuWc2aZ8kkGeXH+PHjKva6nD7wlXHY/LQg=";
      };

      vendorHash = "sha256-2QznJ28lp/+f4MIbu4Wi5Kx46B7IIHGYGofY7B1OEjo=";
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
