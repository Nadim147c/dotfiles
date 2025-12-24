{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "golines";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golines";
    rev = "v${version}";
    hash = "sha256-2eMndvzi1762iPc0tazQQqBb66VVAz1pBr+ow6JnSYY=";
  };

  vendorHash = "sha256-4MNSr1a6V88BYVwU+ZZ4kFOx3KKYbCC2v4Ypziln1LQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A golang formatter that fixes long lines";
    homepage = "https://github.com/golangci/golines";
    license = lib.licenses.mit;
    mainProgram = "golines";
  };
}
