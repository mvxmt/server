{
  description = "A template that shows all standard flake outputs";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.treelarv3.url = "github:ninjawarrior1337/treelarv3";
  inputs.treelarv3.inputs.nixpkgs.follows = "nixpkgs";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = all @ {
    self,
    nixpkgs,
    treelarv3,
    flake-utils,
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
  } // flake-utils.lib.eachDefaultSystem (system: let 
    pkgs = import nixpkgs {
      inherit system;
    };
  in{
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        bfg-repo-cleaner
        just
        nurl
      ];
    };

    packages.getKeys = pkgs.writeShellScriptBin "getKeys" ''
      USER=$1
      nix hash to-sri --type sha256 $(nix-prefetch-url https://github.com/$USER.keys)
    '';
  });
}
