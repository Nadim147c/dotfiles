{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "nix-ld";
  options = delib.singleEnableOption true;
  nixos.ifEnabled.programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      acl
      attr
      bzip2
      curl
      libsodium
      libssh
      libxml2
      libz
      openssl
      stdenv.cc.cc
      stdenv.cc.cc.lib
      systemd
      util-linux
      xz
      zlib
      zstd
    ];
  };
}
