{
  description = "Create a nixFlakes + nix-darwin + home-manager system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix
        (inputs // { mk-darwin-system = self; });
      m1 = import ./lib/m1.nix { inherit mkDarwinSystem flake-utils nixpkgs; };
      mkFunctor = f: nixpkgs.lib.setFunctionArgs f (nixpkgs.lib.functionArgs f);

      templates = rec {
        minimal = {
          description = "mkDarwinSystem minimal example";
          path = ./templates/minimal;
        };

        dev-envs = {
          description = "mkDarwinSystem with direnv devloper environments";
          path = ./templates/dev-envs;
        };

        niv-managed-apps = {
          description = "mkDarwinSystem with macos apps managed with niv";
          path = ./templates/niv-managed-apps;
        };

        default = minimal;
      };
    in {
      inherit templates;

      mkDarwinSystem = (mkFunctor mkDarwinSystem) // {
        m1 = m1.apply;
        lib = import ./lib { inherit nixpkgs; };
      };

      devShells.aarch64-darwin.default = let
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        intelPkgs = nixpkgs.legacyPackages.x86_64-darwin;
      in pkgs.mkShell { packages = [ pkgs.nixfmt intelPkgs.niv ]; };
    };
}
