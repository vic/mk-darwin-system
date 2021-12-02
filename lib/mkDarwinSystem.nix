{ nixpkgs, flake-utils, nix-darwin, home-manager, mk-darwin-system, ... }:
nixpkgs.lib.fix (mkDarwinSystem:
  { system ? builtins.currentSystem or "aarch64-darwin", modules ? [ ], ...
  }@args:
  let
    evalDarwinConfig =
      import "${nix-darwin}/eval-config.nix" { inherit (nixpkgs) lib; };

    nixosConfiguration = evalDarwinConfig (args // {
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
    });

    defaultPackage = nixosConfiguration.system;

    devShell = nixosConfiguration.pkgs.mkShell {
      packages = nixosConfiguration.config.environment.systemPackages;
    };

    defaultApp = flake-utils.lib.mkApp {
      drv = nixosConfiguration.pkgs.writeScriptBin "activate" ''
        ${defaultPackage}/sw/bin/darwin-rebuild activate --flake . "''${@}"
      '';
    };

    outputs = {
      inherit defaultApp defaultPackage devShell nixosConfiguration;
      inherit (nixosConfiguration) pkgs;
    };

  in outputs)
