{ nixpkgs, flake-utils, nix-darwin, home-manager, mk-darwin-system, ... }:
nixpkgs.lib.fix (mkDarwinSystem:
  { flakePath ? ".", system ? builtins.currentSystem or "aarch64-darwin"
  , modules ? [ ], ... }@args:
  let
    evalDarwinConfig =
      import "${nix-darwin}/eval-config.nix" { inherit (nixpkgs) lib; };

    darwinConfiguration = evalDarwinConfig {
      inherit system;
      inputs = {
        inherit nixpkgs;
        darwin = nix-darwin;
      };
      specialArgs = {
        lib = nixpkgs.lib.extend (self: super: {
          inherit (home-manager.lib) hm;
          mds = mk-darwin-system.mkDarwinSystem.lib {
            lib = self;
            pkgs = import nixpkgs { inherit system; };
          };
        });
      };
      modules = [
        nix-darwin.darwinModules.flakeOverrides
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config = {
            localSystem = system;
            crossSystem = system;
          };
        }
        ./../modules
      ] ++ modules;
    };

    defaultPackage = darwinConfiguration.system;

    devShell = darwinConfiguration.pkgs.mkShell {
      packages = darwinConfiguration.config.environment.systemPackages;
    };

    defaultApp = flake-utils.lib.mkApp {
      drv = darwinConfiguration.pkgs.writeScriptBin "darwin-flake-switch" ''
        if [ -z "$*" ]; then
          exec ${darwinConfiguration.system}/sw/bin/darwin-rebuild --flake ${flakePath} switch
        else
          exec ${darwinConfiguration.system}/sw/bin/darwin-rebuild --flake ${flakePath} "''${@}"
        fi
      '';
    };

    outputs = {
      inherit defaultApp darwinConfiguration;
      inherit (darwinConfiguration) pkgs;
      devShells.default = devShell;
      packages.default = defaultPackage;
    };

  in outputs)
