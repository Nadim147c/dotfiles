final: prev: {
    chromashift = final.callPackage ../pkgs/chromashift.nix {};
    compile-scss = final.callPackage ../pkgs/compile-scss.nix {};
    crop-image = final.callPackage ../pkgs/crop-image.nix {};
    desktop-portal-starter = final.callPackage ../pkgs/desktop-portal-starter.nix {};
    dunst-mode-cycle = final.callPackage ../pkgs/dunst-mode-cycle.nix {};
    git-sb = final.callPackage ../pkgs/git-sb.nix {};
    image-detect = final.callPackage ../pkgs/image-detect.nix {};
    pfp = final.callPackage ../pkgs/pfp.nix {};
    tmux-sessionizer = final.callPackage ../pkgs/tmux-sessionizer.nix {};
    wallpaper-sh = final.callPackage ../pkgs/wallpaper-sh.nix {};
    waybar-lyric = final.callPackage ../pkgs/waybar-lyric.nix {};
    go-modules = final.callPackage ../go {};

    cmatrix = prev.cmatrix.overrideAttrs (old: {
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -DHAVE_USE_DEFAULT_COLORS";
    });
}
