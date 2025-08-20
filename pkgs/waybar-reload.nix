{
  coreutils,
  hyprland,
  jq,
  writeShellApplication,
  waybar,
}:
writeShellApplication {
  name = "waybar-reload";

  runtimeInputs = [hyprland jq coreutils waybar];

  text = ''
    hyprctl layers -j |
        jq -r 'to_entries[].value.levels | to_entries[].value.[] | select(.namespace == "waybar").pid' |
        xargs kill
    hyprctl dispatch exec waybar
  '';
}
