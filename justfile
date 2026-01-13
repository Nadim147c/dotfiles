nixos:
  sudo nixos-rebuild switch --flake . -L

boot:
  sudo nixos-rebuild boot --flake . -L

fmt:
  treefmt
