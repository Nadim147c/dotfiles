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
        let thumb_dir = $"(systemd-path user-state-cache)/rong" | path expand
        let wallpaper_dir = $"(systemd-path user-videos)/wallpapers" | path expand

        let format = {|filename|
            let realpath = $filename | path expand
            let hash = $realpath | hash md5

             # requires rong --preview-format jpg
            let thumb = $"($thumb_dir)/($hash).jpg" | path expand

            if ($thumb | path exists)  {
                return { filename: $realpath, preview: $thumb}
            }
        }

        ls --all $wallpaper_dir
            | where type == file
            | sort-by modified --reverse
            | get name
            | each $format
            | to json --raw
    '';
}
