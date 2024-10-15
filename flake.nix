{
  description = "A template that shows all standard flake outputs";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.treelarv3.url = "github::ninjawarrior1337/treelarv3";
  inputs.treelarv3.inputs.nixpkgs.follows = "nixpkgs";

  outputs = all @ {
    self,
    nixpkgs,
    treelarv3,
    ...
  }: {
    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.mvxmt = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        treelarv3.nixosModules.default
        ./configuration.nix

        {
          services.treelarv3.enable = true;
        }
      ];
    };
  };
}
