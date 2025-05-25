# Organize files in a directory
def "organize files" [
    directory?: string # Directory to organize files
] {
    let dir = ($directory | path expand)
    print $dir

    mut files = (ls --mime-type)
    if $dir != null {
        $files = (ls --mime-type ($dir | path expand))
    }

    def move [cat: string, file: string] {
        let base = ($file | path basename)
        let new_path = $"($dir)/($cat)/($base)"
        mkdir -v ($new_path | path dirname)
        mv -v $file $new_path
    }

    for file in $files {
        let type = $file.type
        if ($type | str starts-with "image/") { move "Image" $file.name }
        if ($type | str starts-with "video/") { move "Video" $file.name }
        if ($type | str starts-with "audio/") { move "Audio" $file.name }
        if ($type | str starts-with "text/" ) { move "Document" $file.name }

        if ($type | str ends-with "/pdf" ) { move "Document" $file.name }
        if ($type | str ends-with "/zip") { move "Audio" $file.name }
    }
}
