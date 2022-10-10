{ nixpkgs, flake-utils, nix-darwin, home-manager, ...}@mkdw-inputs:
{
  inputs ? mkdw-inputs,
  flake,
  hostName,
  hostModules ? [ "${flake}/nix/hostConfigurations/${hostName}.nix" ],
  userName,
  userModules ? [ "${flake}/nix/homeConfigurations/${userName}.nix" ],
  userHome ? "/Users/${userName}",
  rootModules ? []
}:
let
  flakeInputs = inputs // {
    inherit flake;
    nivSources = import "${flake}/nix/sources.nix";
  };

  modules = [
    { imports = rootModules; }
    (import ./modules/mk-host.nix { inherit hostName hostModules; })
    (import ./modules/mk-user.nix { inherit userName userHome userModules; })
    ./modules/activation-diff.nix
    ./modules/darwin-rebuild-overlay.nix
    ./modules/intel-overlay.nix
    ./modules/home-manager.nix
    home-manager.darwinModules.home-manager
  ];

  perSystem = flake-utils.lib.eachSystem ["aarch64-darwin"] (system:
    let
      darwin = nix-darwin.lib.darwinSystem {
        inherit system modules; inputs = flakeInputs;
      };
    in {
      packages.default = darwin.system;
      apps.default = flake-utils.lib.mkApp { drv = darwin.pkgs.darwin-rebuild; };
      checks.default = darwin.system;
      devShells.default = darwin.pkgs.mkShell {
        buildInputs = with darwin.pkgs; [ nixVersions.stable niv alejandra ];
      };
    });

  global = {
    darwinConfigurations."${hostName}" = perSystem.aarch64-darwin.packages.default;
  };

in global // perSystem
