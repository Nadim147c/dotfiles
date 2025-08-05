final: prev: {
    compile-scss = final.callPackage ../pkgs/compile-scss.nix {};
    dunst-mode-cycle = final.callPackage ../pkgs/dunst-mode-cycle.nix {};
    git-sb = final.callPackage ../pkgs/git-sb.nix {};
    image-detect = final.callPackage ../pkgs/image-detect.nix {};
    wallpaper-sh = final.callPackage ../pkgs/wallpaper-sh.nix {};
    waybar-lyric = final.callPackage ../pkgs/waybar-lyric.nix {};
    chromashift = final.callPackage ../pkgs/chromashift.nix {};
    desktop-portal-starter = final.callPackage ../pkgs/desktop-portal-starter.nix {};
    go-modules = final.callPackage ../go {};
}
