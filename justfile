switch:
  #!/bin/sh
  if nh os build .; then
    notify-send "NixOS Build ✅" "nh os build succeeded — switching now"
    nh os switch .
  else
    notify-send "NixOS Build ❌" "nh os build failed"
    exit 1
  fi

nixos:
  sudo nixos-rebuild switch --flake . -L
boot:
  sudo nixos-rebuild boot --flake . -L
