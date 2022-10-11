{
  self,
  nixpkgs,
  flake-utils,
  ...
} @ inputs: {
  mkFlake = import ./mk-darwin-flake.nix inputs;

  templates = rec {
    default = minimal;

    minimal = {
      description = "mkDarwinSystem minimal example";
      path = ./../templates/minimal;
    };
  };

  checks = import ./flake-checks.nix inputs;

  apps.aarch64-darwin = let
    pkgs = import nixpkgs {system = "aarch64-darwin";};
  in {
    format = flake-utils.lib.mkApp {drv = pkgs.alejandra;};
  };
}
