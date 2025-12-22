{
  delib,
  pkgs,
  ...
}:
delib.script {
  name = "organize-files";
  package = pkgs.writers.writeNuBin "organize-files" /* nu */ ''
    def main [name?: string] {
        let dir = if $name != null { $name } else { $env.PWD }
        let files = ls --mime-type --all $dir
        let detect_mime = {|file|
            let src = $file.name | path expand
            let mime = $file.type

            if $mime == dir { return }

            # Media types
            if $mime starts-with "image/" { return { type: "image", src: $src } }
            if $mime starts-with "video/" { return { type: "video", src: $src } }
            if $mime starts-with "audio/" { return { type: "audio", src: $src } }

            # Specific MIME maps
            let type = match $mime {
                # Archives
                "application/zip" => "archive"
                "application/x-rar-compressed" => "archive"
                "application/vnd.rar" => "archive"
                "application/x-7z-compressed" => "archive"
                "application/x-tar" => "archive"
                "application/gzip" => "archive"
                "application/x-gzip" => "archive"
                "application/x-bzip2" => "archive"
                "application/x-xz" => "archive"
                "application/x-iso9660-image" => "disk"
                "application/x-qemu-disk" => "disk"
                "application/vnd.vmware.vmdk" => "disk"

                # Documents
                "application/pdf" => "document"
                "application/msword" => "document"
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document" => "document"
                "application/vnd.ms-powerpoint" => "document"
                "application/vnd.openxmlformats-officedocument.presentationml.presentation" => "document"
                "application/vnd.ms-excel" => "document"
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" => "document"
                "application/epub+zip" => "document"
                "text/plain" => "text"
                "text/markdown" => "text"
                "text/html" => "text"
                "text/css" => "text"
                "application/json" => "text"
                "application/xml" => "text"
                "text/javascript" => "script"
                "application/javascript" => "script"
                "text/x-python" => "script"
                "application/x-python-code" => "script"
                "text/x-shellscript" => "script"

                # Fonts
                "font/ttf" => "font"
                "font/otf" => "font"
                "font/woff" => "font"
                "font/woff2" => "font"

                # Executables / binaries
                "application/x-executable" => "binary"
                "application/x-sharedlib" => "binary"
                "application/x-appimage" => "binary"
                "application/vnd.appimage" => "binary"
                "application/x-elf" => "binary"
                "application/vnd.android.package-archive" => "apk"
                "application/x-msdownload" => "exe"
                "application/vnd.microsoft.portable-executable" => "exe"

                _ => "unknown"
            }

            return { type: $type, src: $src }
        }

        # Destination folders
        let destinations = {
            image: (systemd-path user-pictures)
            video: (systemd-path user-videos)
            audio: (systemd-path user-music)
            document: (systemd-path user-documents)
            text: (systemd-path user-documents)
            script: (systemd-path user-documents)
            archive: (systemd-path user-documents | path dirname | path join archives)
            font: (systemd-path user-documents | path dirname | path join fonts)
            binary: (systemd-path user-documents | path dirname | path join binaries)
            apk: (systemd-path user-documents | path dirname | path join android_apps)
            exe: (systemd-path user-documents | path dirname | path join executables)
            disk: (systemd-path user-documents | path dirname | path join disk_images)
            unknown: (systemd-path user-documents | path dirname | path join unknown)
        }

        let organize = {|file|
            let target = $destinations | get $file.type
            if $target == null {
                print $"Unknown destination for type ($file.type), skipping: ($file.src)"
                return
            }

            # Make directory if it doesn't exist
            mkdir $target
            move $file.src $target
        }

        # Process and move
        $files | each $detect_mime | each $organize | ignore
    }

    def move [src: string, dst: string] {
        let hash = xxhsum $src | split words | first
        let meta = file --extension $src
        if $meta =~ "^.+: .+$" {
            let ext = $meta | split row : | last | split words | first
            print (^mv --force --update --verbose $src $"($dst)/($hash).($ext)")
        } else {
            print (^mv --force --update --verbose $src $"($dst)/($hash)")
        }
    }
  '';
}
