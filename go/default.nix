{
    buildGoModule,
    installShellFiles,
    lib,
    stdenv,
    ...
}:
buildGoModule (finalAttr: {
    pname = "go-modules";
    version = "1.0.0";
    src = ./.;
    proxyVendor = true;
    doCheck = false;
    vendorHash = "sha256-V/4zpE7aLe/tRzn53gDYhASR1e0T5RR2ZQ8VlDoavFA=";

    nativeBuildInputs = [installShellFiles];

    postInstall =
        lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
        /*
    bash
    */
        ''
            for bin in $out/bin/*; do
                bashComp="$($bin _carapace bash)"
                fishComp="$($bin _carapace fish)"
                zshComp="$($bin _carapace zsh)"

                installShellCompletion --cmd $(basename $bin) \
                    --bash <(echo "$bashComp") \
                    --fish <(echo "$fishComp") \
                    --zsh <(echo "$zshComp")
            done
        '';
})
