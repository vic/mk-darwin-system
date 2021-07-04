{ nixpkgs, ... }@args:
(nixpkgs.lib.fix (mkDarwinSystem:
  { hostName, system, nixpkgs, nix-darwin, flake-utils, home-manager
  , nixosModules ? [ ]
  , flakeOutputs ? nixpkgs.lib.id
  , silliconOverlay ? (silliconPkgs: intelPkgs: {})
  , ... }@args:
  let
    darwinConfig = import "${nix-darwin}/eval-config.nix" {
      inherit (nixpkgs) lib;
      inherit system;
    };

    silliconBackportOverlay = new: old:
      let
        sillicon = "aarch64-darwin";
        intel = "x86_64-darwin";
        intelSystem = mkDarwinSystem (args // { system = intel; });
      in if system == sillicon then {
        # TODO: Remove when PR gets merged. https://github.com/NixOS/nixpkgs/pull/126195
        inherit (intelSystem.pkgs) haskell haskellPackages;
        inherit (silliconOverlay old intelSystem.pkgs);
      } else { };

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
        { nixpkgs.overlays = [ nixpkgsOverlay silliconBackportOverlay ]; }
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
      drv = nixosConfiguration.pkgs.writeScriptBin "system-switch"
        "exec ${defaultPackage}/sw/bin/darwin-rebuild switch --flake";
    };

    outputs = {
      inherit defaultApp defaultPackage devShell;
      pkgs = nixosConfiguration.pkgs;
      nixosConfigurations.${hostName} = nixosConfiguration;
    };

  in flakeOutputs outputs)) args
