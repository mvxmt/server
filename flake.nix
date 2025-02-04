{
  description = "mvxmt flake def";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = all @ {
    self,
    nixpkgs,
    treelarv3,
    flake-utils,
    ...
  }:
    {
      # Used with `nixos-rebuild --flake .#<hostname>`
      # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation

      nixosConfigurations.mvxmt = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          bfg-repo-cleaner
          just
          nurl
        ];
      };

      packages.hashKeys = pkgs.writeShellScriptBin "getKeys" ''
        USER=$1
        nix hash convert --hash-algo sha256 $(nix-prefetch-url https://github.com/$USER.keys)
      '';
    });
}
