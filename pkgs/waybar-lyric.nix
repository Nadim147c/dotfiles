{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "waybar-lyric";
  version = "unstable-2025-07-19";

  src = fetchFromGitHub {
    owner = "Nadim147c";
    repo = "waybar-lyric";
    rev = "3f78edfb43edc997437d35a939d70f6bc4d47de6";
    hash = "sha256-dq72i+B0yDCF5mi/muLyyZ86UIcOIgDqSsQxVRYZeNU=";
  };

  vendorHash = "sha256-DBtSC+ePl6dvHqB10FyeojnYoT3mmsWAnbs/lZLibl8=";

  doInstallCheck = true;

  versionCheckKeepEnvironment = ["XDG_CACHE_HOME"];
  preInstallCheck = ''
    # ERROR Failed to find cache directory
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  meta = {
    description = "Waybar module for displaying song lyrics";
    homepage = "https://github.com/Nadim147c/waybar-lyric";
    license = lib.licenses.agpl3Only;
    mainProgram = "waybar-lyric";
    maintainers = with lib.maintainers; [vanadium5000];
    platforms = lib.platforms.linux;
  };
})
