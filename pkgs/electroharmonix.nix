{
  lib,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "electroharmonix";
  version = "1.0.0";
  src = ./electroharmonix;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp $src/Electroharmonix.otf $out/share/fonts/opentype/Electroharmonix.otf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Electroharmonix font installed from local file";
    homepage = "https://www.dafont.com/electroharmonix.font";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
