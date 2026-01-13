{
  delib,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) escapeShellArgs;
  runtimeInputs = with pkgs; [
    slurp
    grim
  ];
  PATH = map (x: "${x}/bin") runtimeInputs |> escapeShellArgs;
in
delib.script rec {
  name = "screenshot";
  partof = "programs.hyprland";
  package = pkgs.writers.writeNuBin name /* nu */ ''
    $env.PATH = [ ${PATH} ] ++ $env.PATH

    def main [] { main region }

    def 'main region' [] {
      let name = (date now | format date "%Y-%m-%d_%H:%M:%S")
      let temp_file = $"/tmp/screenshot_($name).png"
      let final_path = $"(systemd-path user-pictures)/screenshot/($name).png"
      mkdir -v ($final_path | path dirname)

      let colors = get_colors
      let region = (slurp -d -b $colors.background -c $colors.outline)
      print $"Captured a region ($region)"
      grim -g $region $temp_file

      let action = (notify-send "Screenshot Captured" "Saved to clipboard"
        --expire-time="5000"
        --icon $temp_file
        --action="annotate=Annotate"
        --action="delete=Delete")

      if ($action == "annotate") {
        (satty --filename $temp_file
          --output-filename $final_path
          --early-exit
          --copy-command wl-copy)
      } else if ($action == "delete") {
        rm -vf $final_path
      } else {
        cp --verbose $temp_file $final_path
      }
      rm -vf $temp_file
    }

    def 'main screen' [] {
      let name = (date now | format date "%Y-%m-%d_%H:%M:%S")
      let temp_file = $"/tmp/screenshot_($name).png"
      let final_path = $"(systemd-path user-pictures)/screenshot/($name).png"
      mkdir -v ($final_path | path dirname)
      grim $temp_file

      let action = (notify-send "Screenshot Captured" "Saved to clipboard"
        --expire-time="5000"
        --icon=$temp_file
        --action="delete=Delete"
        --action="annotate=Annotate")

      if ($action == "annotate") {
        (satty --filename $temp_file
          --output-filename $final_path
          --early-exit
          --copy-command wl-copy)
      } else if ($action == "delete") {
        rm -vf $final_path
      } else {
        cp --verbose $temp_file $final_path
      }
      rm -vf $temp_file
    }

    def get_colors [] {
      try {
        let colors =  open $"(systemd-path user-state-private)/rong/colors.json"
        | select material.background.hex_rgb material.outline.hex_rgb
        | rename background outline
        | upsert background {|it| $it.background + "88"}  # semi transparent
        return  $colors
      } catch {
        return {
          background: ("#222222" + "88") # semi transparent
          outline: "#111111"
        }
      }
    }
  '';
}
