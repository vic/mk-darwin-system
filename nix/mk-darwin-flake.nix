{ nixpkgs, flake-utils, nix-darwin, home-manager, ...}@inputs: flake:
{
  hostName,
  hostModules,
  userName,
  userModules,
  userHome ? "/Users/${userName}"
}:
let
  global = {
    darwinConfigurations."${hostName}" = flake.self.packages.aarch64-darwin.default;
  };

  modules = [
    (import ./modules/mk-host.nix { inherit hostName hostModules; })
    (import ./modules/mk-user.nix { inherit userName userHome userModules; })
    ./modules/activation-diff.nix
    ./modules/darwin-rebuild-overlay.nix
    ./modules/intel-overlay.nix
    ./modules/home-manager.nix
    home-manager.darwinModules.home-manager
  ];

  perSystem = system: let
    darwin = nix-darwin.lib.darwinSystem {
      inherit system modules;
      inputs = inputs // flake;
    };
  in {
    packages.default = darwin.system;
    apps.default = flake-utils.lib.mkApp { drv = darwin.pkgs.darwin-rebuild; };
    checks.default = darwin.system;
  };

in global // flake-utils.lib.eachSystem ["aarch64-darwin"] perSystem
