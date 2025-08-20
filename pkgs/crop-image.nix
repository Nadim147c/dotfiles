{
  writers,
  imagemagick,
}:
writers.writePython3Bin "crop-image" {doCheck = false;} ''
  import argparse
  import os
  import re
  import subprocess
  from pathlib import Path

  def calculate_crop(ratio, width, height):
      new_width = round(height * ratio)
      new_height = round(width / ratio)
      final_width = min(new_width, width)
      final_height = min(new_height, height)
      x = round((width - final_width) / 2)
      y = round((height - final_height) / 2)
      return (x, y, final_width, final_height)

  def main():
      parser = argparse.ArgumentParser(description='Crop an image to specified aspect ratio')
      parser.add_argument('input', help='Path to input image')
      parser.add_argument('output', nargs='?', help='Output path (default: <input_stem>_<W>x<H>.<ext>)')
      parser.add_argument('--ratio', default='1', help='Aspect ratio (e.g. 16:9, 1/2, 18x9)')
      parser.add_argument('--debug', action='store_true', help='Print debug information')
      args = parser.parse_args()

      # Expand and verify input path
      input_path = os.path.abspath(args.input)
      if not os.path.exists(input_path):
          raise FileNotFoundError(f"Input image does not exist: {input_path}")

      # Get image dimensions
      result = subprocess.run(
          ['${imagemagick}/bin/identify', '-format', '%w %h', input_path],
          capture_output=True, text=True, check=True
      )
      width, height = map(int, result.stdout.split())

      # Parse aspect ratio
      ratio_parts = re.split(r'[:/x]', args.ratio)
      if len(ratio_parts) == 1:
          aspect_ratio = float(ratio_parts[0])
      elif len(ratio_parts) == 2:
          aspect_ratio = float(ratio_parts[0]) / float(ratio_parts[1])
      else:
          raise ValueError(f"Invalid ratio format: {args.ratio}")

      # Calculate crop dimensions
      x, y, crop_w, crop_h = calculate_crop(aspect_ratio, width, height)

      if args.debug:
          print(f"Crop settings: x={x}, y={y}, width={crop_w}, height={crop_h}")

      # Determine output path
      output_path = (
          args.output or
          str(Path(input_path).with_stem(
              f"{Path(input_path).stem}_{crop_w}x{crop_h}"
          ))
      )

      # Execute ImageMagick crop command
      subprocess.run([
          '${imagemagick}/bin/magick', input_path,
          '-crop', f'{crop_w}x{crop_h}+{x}+{y}',
          output_path
      ], check=True)

  if __name__ == '__main__':
      main()
''
