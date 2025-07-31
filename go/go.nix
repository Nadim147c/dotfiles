{buildGoModule, ...}: let
    myGoClis = buildGoModule (finalAttr: {
        pname = "my-go-clis";
        version = "1.0.0";
        src = ./.;
        subPackages = [
            "cmd/eww-cava"
        ];

        proxyVendor = true;
    });
in {
    home.packages = [
        myGoClis
    ];
}
