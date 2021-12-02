{
  description = "Create a nixFlakes + nix-darwin + home-manager system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/21.11";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: {
    mkDarwinSystem = let
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix
        (inputs // { mk-darwin-system = self; });
      m1 = import ./lib/m1.nix { inherit mkDarwinSystem flake-utils nixpkgs; };
      mkFunctor = f: nixpkgs.lib.setFunctionArgs f (nixpkgs.lib.functionArgs f);
    in (mkFunctor mkDarwinSystem) // { m1 = m1.apply; };

    defaultTemplate = {
      description = "mkDarwinSystem minimal example";
      path = ./templates/minimal;
    };
  };
}
