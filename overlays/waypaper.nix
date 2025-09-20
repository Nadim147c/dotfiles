{delib, ...}:
delib.overlayModule {
    name = "waypaper";
    overlay = final: prev: {
        waypaper = prev.waypaper.overrideAttrs (old: {
            postFixup =
                (old.postFixup or "")
                + ''
                    # Rename original binary
                    mv $out/bin/waypaper $out/bin/.waypaper-real

                    # Write a bash wrapper that expands $HOME at runtime
                    cat > $out/bin/waypaper <<'EOF'
                    #!${prev.bash}/bin/bash
                    exec setsid "$(dirname "$0")/.waypaper-real" --folder "$HOME/Videos/Wallpapers" "$@"
                    EOF

                    chmod +x $out/bin/waypaper
                '';
        });
    };
}
