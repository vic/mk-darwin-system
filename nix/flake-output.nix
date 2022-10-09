{ nixpkgs, flake-utils, nix-darwin, home-manager, self, ...}@inputs:
let
  hostName = "your-hostname";
  userName = "your-username";
  userHome = "/Users/${userName}";

  global = {
    darwinConfigurations."${hostName}" = self.packages.aarch64-darwin.default;
  };

  modules = [
    (import ./modules/mk-host.nix { inherit hostName; })
    (import ./modules/mk-user.nix { inherit userName userHome; })
    ./modules/activation-diff.nix
    ./modules/darwin-rebuild-overlay.nix
    ./modules/intel-overlay.nix
    ./modules/home-manager.nix
    home-manager.darwinModules.home-manager
  ];

  perSystem = system: let
    darwin = nix-darwin.lib.darwinSystem { inherit system modules inputs; };
  in {
    packages.default = darwin.system;
    apps.default = flake-utils.lib.mkApp { drv = darwin.pkgs.darwin-rebuild; };
  };

in global // flake-utils.lib.eachSystem ["aarch64-darwin"] perSystem
