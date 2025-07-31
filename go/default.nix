{buildGoModule, ...}:
buildGoModule (finalAttr: {
    pname = "my-go-clis";
    version = "1.0.0";
    src = ./.;
    proxyVendor = true;
    doCheck = false;
    vendorHash = "sha256-V/4zpE7aLe/tRzn53gDYhASR1e0T5RR2ZQ8VlDoavFA=";
    postBuild = ''
        for bin in $out/bin/*; do
        $bin _carapace fish > ~/.config/fish/completions/$(basename $bin).fish
        done
    '';
})
