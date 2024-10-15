{
  description = "A template that shows all standard flake outputs";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = all @ {
    self,
    nixpkgs,
    ...
  }: {
    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.mvxmt = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
