{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  qt6,
  stdenv,
}:
let
  prefix = qt6.qtbase.qtQmlPrefix;
in
stdenv.mkDerivation rec {
  pname = "qt-m3shapes";
  version = "0-unstable-2026-01-15";

  src = fetchFromGitHub {
    owner = "soramanew";
    repo = "m3shapes";
    rev = "9b3562b4f8221cf5e9a7dcdd9a5041147bedca3d";
    hash = "sha256-lLZwN0viokZQxPJPO/jyasSA40ddyTo7UZuh4VnTpqQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = with qt6; [
    qtbase
    qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    (lib.cmakeFeature "INSTALL_QMLDIR" "${placeholder "out"}/${prefix}")
    (lib.cmakeFeature "INSTALL_QML_PREFIX" "${placeholder "out"}/${prefix}")
  ];

  postFixup = ''
    patchelf \
      --set-rpath "$out/${prefix}/M3Shapes:${lib.makeLibraryPath buildInputs}" \
      $out/${prefix}/M3Shapes/libm3shapesplugin.so
  '';

  meta = {
    description = "A QT port of the androidx shape library";
    homepage = "https://github.com/soramanew/m3shapes";
    platforms = lib.platforms.linux;
  };
}
