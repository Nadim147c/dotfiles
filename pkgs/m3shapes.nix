{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  pkg-config,
  qt6,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "m3shapes";
  version = "unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "soramanew";
    repo = "m3shapes";
    rev = "0957a15029c07355a88843ada3f8c7fea4408b5f";
    hash = "sha256-3gB7AYHsKX8/KdtigIny/OlUy6ZC4JIjPx3NBmYZDD4=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = with qt6; [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "INSTALL_QMLDIR" "${placeholder "out"}/lib/qt-6/qml")
  ];

  postFixup = ''
    patchelf \
      --set-rpath "$out/lib/qt-6/qml/M3Shapes:${lib.makeLibraryPath buildInputs}" \
      $out/lib/qt-6/qml/M3Shapes/libm3shapesplugin.so
  '';

  meta = {
    description = "A QT port of the androidx shape library";
    homepage = "https://github.com/soramanew/m3shapes";
    # license = lib.licenses.unfree;
    # maintainers = with lib.maintainers; [ ];
    mainProgram = "m3shapes";
    platforms = lib.platforms.linux;
  };
}
