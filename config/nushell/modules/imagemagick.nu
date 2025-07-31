def calculate_crop [ratio: float, width: int, height: int] {
    let new_width = ($height * $ratio | math round)
    let new_height = ($width / $ratio | math round)
    let final_width = if ($new_width <= $width) { $new_width } else { $width }
    let final_height = if ($new_height <= $height) { $new_height } else { $height }
    let x = (($width - $final_width) / 2 | math round)
    let y = (($height - $final_height) / 2 | math round)
    { x: $x, y: $y, w: $final_width, h: $final_height }
}

def "crop image" [
    input: string, # Path to the input image
    output?: string, # Optional path to save the cropped image
    --ratio = "1": string, # Aspect ratio for cropping (e.g., '16:9', '1/2', '18x9')
    --top: int, # Number of pixels to add to the top after cropping
    --bottom: int, # Number of pixels to add to the bottom after cropping
    --left: int, # Number of pixels to add to the left after cropping
    --right: int, # Number of pixels to add to the right after cropping
    --around: int, # Number of pixels to add evenly around the cropped area
    --debug # Print debug information about the crop settings
] {
    let input = ($input | path expand)
    if not ($input | path exists) {
        error make -u {msg: "Input image does not exist"}
    }

    let size = (identify -format '%w %h' $input | split row ' ' | into int)
    let image_width = $size.0
    let image_height = $size.1

    let size = ($ratio | split row --regex '/|:|x' | into float)
    let crop = if ($size | length) == 2 {
        let r = ($size.0 / $size.1)
        calculate_crop $r $image_width $image_height
    } else {
        calculate_crop $size.0 $image_width $image_height
    }

    let outfile = if $output == null {
        let path_meta = ($input | path parse)
        $path_meta.parent | path join $"($path_meta.stem)_($crop.w)x($crop.h).($path_meta.extension)"
    } else {
        $output
    }

    if $debug {
        print "Crop settings: ($crop)"
    }

    magick $input -crop $"($crop.w)x($crop.h)+($crop.x)+($crop.y)" $outfile
}
