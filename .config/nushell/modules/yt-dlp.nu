def yt_dlp_video_container [] {
    [mp4 avi flv mkv mov webm]
}

# Download video using yt-dlp
def "video" [
    --format: string # Yt-dlp format for download
    --resulation = 1080: int # Resulation of video to download
    --cookie: string # Netscape formatted file to read cookies from and dump cookie jar in
    --extention = "mp4": string@yt_dlp_video_container # Video container to use when merging audio and video
    --threads = 4: int # Number of concurrent downloads
    --browser: string # Name of the browser to use cookies from
    --sections: string # Section of the video to download. timestamp must start with * (ex: '*0.11-0.50')"
    --save = "~/Downloads/Videos": string # Where to save downloaded video
    --no-metadata # Disable embed metadata
    url: string # URL of the video to download
]: nothing -> any {
    let filename = "%(title)s-%(id)s.%(ext)s"
    mut flags = [
        $"--output=($save | path expand)/($filename)"
        $"--merge-output-format=($extention)"
        $"--concurrent-fragments=($threads)"

        --sponsorblock-mark=all
        --sub-langs=all
        --embed-subs
        --list-formats
        --no-simulate
        --color=always
    ]

    if (not $no_metadata) {
        $flags ++= [
            --embed-thumbnail
            --embed-metadata
            --embed-chapters
        ]
    }

    $flags ++= if $format != null {
        [$"--format=($format)"]
    } else {
        [$"--format=\(bv[height<=($resulation)]+ba\)/\(b[height<=($resulation)]\)/b"]
    }

    if $browser != null {
        $flags ++= [$"--cookies-from-browser=($browser)"]

    }

    let flag_str = ($flags | sort | str join " \\\n    ")

    ^yt-dlp ...$flags $url
}
