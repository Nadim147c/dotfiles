
def calculate_crop [ratio: float, width: int, height: int] {
    let new_width = ($height * $ratio | math round)
    let new_height = ($width / $ratio | math round)
    let final_width = if ($new_width <= $width) { $new_width } else { $width }
    let final_height = if ($new_height <= $height) { $new_height } else { $height }
    let x = (($width - $final_width) / 2 | math round)
    let y = (($height - $final_height) / 2 | math round)
    { x: $x, y: $y, w: $final_width, h: $final_height }
}

def "crop video" [
    input: string
    output?: string, # Optional output video path
    --white,         # Auto detect white bar instead of black
    --ratio: string, # Aspect ratio (ex: 16:9, 1/2, 18x9)
    --top: int,      # Pixels to add to top
    --bottom: int,   # Pixels to add to bottom
    --left: int,     # Pixels to add to left
    --right: int,    # Pixels to add to right
    --around: int,   # Pixels to add around
    --threads: int = 4, # Number of threads
    --detection-time (-d): int = 2, # Time in seconds for detection
    --preview,       # Show a preview instead of saving output
    --debug          # Print debug info
] {
    let input = ($input | path expand)
    if not ($input | path exists) {
        error make -u {msg: "Input video does not exist"}
    }

    let meta = (ffprobe -v error -select_streams v:0 -show_entries format=duration -show_entries stream=width,height -of json -i $input | from json)
    let size = ($meta.streams | first)

    mut crop = if $ratio != null {
        mut rat = 0.0

        let rows = ($ratio | split row --regex '/|:|x')
        if ($rows | length) == 1 { $rat = ($rows | first) }
        if ($rows | length) >= 2 { $rat = ($rows.0 | into int) / ($rows.1 | into int) }

        if $rat == 0 {
            error make -u {msg: $"Invalid ratio ($ratio)"}
        }

        $rat = ($rat | into float)
        calculate_crop $rat $size.width $size.height
    } else {
        let crop_filter = if $white { "eq=contrast=1.8,negate,cropdetect" } else { "eq=contrast=1.8,cropdetect" }
        let detected_crop = (ffmpeg -i $input -t $detection_time -vf $crop_filter -f null - e>|
            rg -o 'crop=\d+:\d+:\d+:\d+' |
            lines | last | split row '=' | last | split row ':')

        print $detected_crop
        {
            w: ($detected_crop.0 | into int)
            h: ($detected_crop.1 | into int)
            x: ($detected_crop.2 | into int)
            y: ($detected_crop.3 | into int)
        }

    }

    if $top != null { $crop.y -= $top; $crop.h += $top }
    if $bottom != null { $crop.h += $bottom }
    if $left != null { $crop.x -= $left; $crop.w += $left }
    if $right != null { $crop.w += $right }
    if $around != null { $crop.y -= $around; $crop.h += (2 * $around); $crop.x -= $around; $crop.w += (2 * $around) }

    if $crop.x < 0 { $crop.x = 0 }
    if $crop.y < 0 { $crop.y = 0 }
    if $crop.w > $size.width { $crop.w = $size.width }
    if $crop.h > $size.height { $crop.h = $size.height }

    let outfile = if $output == null {
        let path_meta = ($input | path parse)
        $path_meta.parent | path join $"($path_meta.stem)_($crop.w)x($crop.h).($path_meta.extension)"
    } else {
        $output
    }

    if $debug {
        print $"Crop settings: ($crop)"
    }

    if $preview {
        let preview_filter = $"crop=($crop.w):($crop.h):($crop.x):($crop.y),scale=300:-1"
        ffplay -i $input -vf $preview_filter
    } else {
        ffmpeg -i $input -threads $threads -vf $"crop=($crop.w):($crop.h):($crop.x):($crop.y)" $outfile
    }
}
