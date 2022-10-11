{
  nixpkgs,
  flake-utils,
  nix-darwin,
  home-manager,
  ...
} @ mkdw-inputs: {
  inputs ? mkdw-inputs,
  flake,
  hostName,
  hostModules ? ["${flake}/nix/hostConfigurations/${hostName}.nix"],
  userName,
  userModules ? ["${flake}/nix/homeConfigurations/${userName}.nix"],
  userHome ? "/Users/${userName}",
  rootModules ? [],
}: let
  flakeInputs =
    mkdw-inputs
    // inputs
    // {
      inherit flake;
      nivSources = let
        f = "${flake}/nix/sources.nix";
      in
        if builtins.pathExists f
        then import f
        else {};
    };

  modules = [
    {_module.args.flake = flake;}
    {imports = rootModules;}
    (import ./modules/mk-host.nix {inherit hostName hostModules;})
    (import ./modules/mk-user.nix {inherit userName userHome userModules;})
    ./modules/activation-diff.nix
    ./modules/darwin-rebuild-overlay.nix
    ./modules/intel-overlay.nix
    ./modules/home-manager.nix
    ./modules/niv-managed-dmg-overlay.nix
    home-manager.darwinModules.home-manager
  ];

  darwin = nix-darwin.lib.darwinSystem {
    inherit modules;
    system = "aarch64-darwin";
    inputs = flakeInputs;
  };

  perSystem = flake-utils.lib.eachSystem ["aarch64-darwin"] (system:
    with darwin.pkgs; {
      packages.default = darwin.system;
      apps.default = flake-utils.lib.mkApp {drv = darwin-rebuild;};
      apps.format = flake-utils.lib.mkApp {drv = alejandra;};
      checks.default = darwin.system;
      devShells.default = mkShell {
        buildInputs = [nixVersions.stable niv alejandra];
      };
    });

  global = {
    darwinConfigurations.${hostName} = darwin;
  };
in
  global // perSystem
