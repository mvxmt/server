switch:
    sudo nixos-rebuild --flake . switch

up:
    nix flake update
    just switch