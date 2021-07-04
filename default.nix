{ nixpkgs, ...} @args:
  (nixpkgs.lib.fix (mkDarwinSystem:
  { hostName, system, nixpkgs, nix-darwin, flake-utils, home-manager
    , nixosModules ? [ ], ... }@args:
  let
    darwinConfig = import "${nix-darwin}/eval-config.nix" {
      inherit (nixpkgs) lib;
      inherit system;
    };

    silliconBackportOverlay = (new: old:
      let
        sillicon = "aarch64-darwin";
        intel = "x86_64-darwin";
        intelSystem = mkDarwinSystem (args // { system = intel; });
      in if system == sillicon then
        {
          # TODO: Remove when PR gets merged. https://github.com/NixOS/nixpkgs/pull/126195
          inherit (intelSystem.pkgs) haskell haskellPackages;
        }
      else
        { });

    nixosConfiguration = darwinConfig {
      modules = nixosModules ++ [
        nix-darwin.darwinModules.flakeOverrides
        home-manager.darwinModules.home-manager
        { nixpkgs.overlays = [ silliconBackportOverlay ]; }
      ];
      inputs = {
        inherit nixpkgs;
        darwin = nix-darwin;
      };
    };

    pkgs = nixosConfiguration.pkgs // {
      darwinConfigurations.${hostName}.system = defaultPackage;
      sysEnv = nixosConfiguration.pkgs.buildEnv {
        name = "sysEnv";
        paths = nixosConfiguration.config.environment.systemPackages;
      };
    };

    defaultPackage = nixosConfiguration.system;
    devShell = pkgs.mkShell { buildInputs = [ pkgs.sysEnv ]; };
    defaultApp = flake-utils.lib.mkApp {
      drv = pkgs.writeScriptBin "system-switch"
        "exec ${defaultPackage}/sw/bin/darwin-rebuild switch --flake";
    };
  in {
    inherit defaultApp defaultPackage devShell pkgs;
    nixosConfigurations.${hostName} = nixosConfiguration;
  })) args
