{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...}@inputs: {
    mkDarwinSystem = import ./nix/flake-output.nix inputs;

    templates = rec {
      default = minimal;

      minimal = {
        description = "mkDarwinSystem minimal example";
        path = ./templates/minimal;
      };
    };

    examples.minimal = self.mkDarwinSystem inputs {
      hostName = "your-hostname";
      hostModules = [ ./templates/minimal/nix/hostConfigurations/your-hostname.nix ];
      userName = "your-username";
      userModules = [ ./templates/minimal/nix/homeConfigurations/your-username.nix ];
    };

    checks.aarch64-darwin.minimal = self.examples.minimal.packages.aarch64-darwin.default;
  };
}
