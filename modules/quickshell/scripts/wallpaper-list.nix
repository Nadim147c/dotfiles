{
    delib,
    pkgs,
    ...
}:
delib.script {
    name = "wallpaper-list";
    partof = "programs.quickshell";
    package = pkgs.writers.writeNuBin "wallpaper-list.sh" # nu

    ''
        let generate_colors = {|filename|
            rong video --dry-run --json $filename
                | from json
                | select image material.primary.hex_rgb material.surface.hex_rgb material.on_surface.hex_rgb
                | rename preview primary bg fg
                | upsert filename $filename
                | to json --raw
                | print $in
        }

        let wallpaper_dir = $"(systemd-path user-videos)/wallpapers" | path expand

        ls --all $wallpaper_dir
            | where type == file
            | sort-by modified --reverse
            | get name
            | each $generate_colors
            | ignore
    '';
}
