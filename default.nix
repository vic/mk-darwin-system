{ nixpkgs, self, ... }@args:
(nixpkgs.lib.fix (mkDarwinSystem:
  { hostName, nixpkgs, nix-darwin, flake-utils, home-manager
  , system ? builtins.currentSystem or "aarch64-darwin", nixosModules ? [ ]
  , flakeOutputs ? nixpkgs.lib.id
  , silliconOverlay ? (silliconPkgs: intelPkgs: { }), ... }@args:
  let
    darwinConfig = import "${nix-darwin}/eval-config.nix" {
      inherit (nixpkgs) lib;
      inherit system;
    };

    silliconBackportOverlay = new: old:
      let
        isSillicon = old.stdenv.hostPlatform.isDarwin
          && old.stdenv.hostPlatform.isAarch64;
        intel = "x86_64-darwin";
        intelSystem = mkDarwinSystem (args // { system = intel; });
        intelPkgs = intelSystem.pkgs;
      in if isSillicon then {
        # TODO: Remove when PR gets merged. https://github.com/NixOS/nixpkgs/pull/126195
        inherit (intelPkgs) haskell haskellPackages;

        # Marked as broken in aarch64-darwin
        inherit (intelPkgs)
          llvmPackages_6 llvmPackages_7 llvmPackages_8 llvmPackages_9
          llvmPackages_10;

        inherit (silliconOverlay old intelPkgs)
        ;
      } else
        { };

    nixpkgsOverlay = (new: old: {
      darwinConfigurations.${hostName}.system = defaultPackage;
      sysEnv = new.buildEnv {
        name = "sysEnv";
        paths = nixosConfiguration.config.environment.systemPackages;
      };
    });

    nixosConfiguration = darwinConfig {
      modules = [
        nix-darwin.darwinModules.flakeOverrides
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config = {
            localSystem = system;
            crossSystem = system;
          };
          nixpkgs.overlays = [ nixpkgsOverlay silliconBackportOverlay ];
        }
      ] ++ nixosModules;
      inputs = {
        inherit nixpkgs;
        darwin = nix-darwin;
      };
    };

    defaultPackage = nixosConfiguration.system;
    devShell = nixosConfiguration.pkgs.mkShell {
      packages = [ nixosConfiguration.pkgs.sysEnv ];
    };
    defaultApp = flake-utils.lib.mkApp {
      drv = nixosConfiguration.pkgs.writeScriptBin "switch"
        ''#!${nixosConfiguration.pkgs.bash}/bin/bash
        set -x
        exec ${defaultPackage}/sw/bin/darwin-rebuild switch --flake .
        '';
    };

    outputs = {
      inherit defaultApp defaultPackage devShell;
      pkgs = nixosConfiguration.pkgs;
      nixosConfigurations.${hostName} = nixosConfiguration;
    };

  in flakeOutputs outputs)) args
