{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  qt6,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "m3shapes";
  version = "0-unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "soramanew";
    repo = "m3shapes";
    rev = "0957a15029c07355a88843ada3f8c7fea4408b5f";
    hash = "sha256-3gB7AYHsKX8/KdtigIny/OlUy6ZC4JIjPx3NBmYZDD4=";
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
    (lib.cmakeFeature "INSTALL_QMLDIR" "${placeholder "out"}/${qt6.qtbase.qtQmlPrefix}")
    (lib.cmakeFeature "INSTALL_QML_PREFIX" "${placeholder "out"}/${qt6.qtbase.qtQmlPrefix}")
  ];

  postFixup = ''
    patchelf \
      --set-rpath "$out/${qt6.qtbase.qtQmlPrefix}/M3Shapes:${lib.makeLibraryPath buildInputs}" \
      $out/${qt6.qtbase.qtQmlPrefix}/M3Shapes/libm3shapesplugin.so
  '';

  meta = {
    description = "A QT port of the androidx shape library";
    homepage = "https://github.com/soramanew/m3shapes";
    mainProgram = "m3shapes";
    platforms = lib.platforms.linux;
  };
}
