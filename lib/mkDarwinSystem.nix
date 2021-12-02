{ nixpkgs, flake-utils, nix-darwin, home-manager, mk-darwin-system, ... }:
nixpkgs.lib.fix (mkDarwinSystem:
  { system ? builtins.currentSystem or "aarch64-darwin", nixosModules ? [ ]
  , specialArgs ? nixpkgs.lib.id
  , silliconOverlay ? (silliconPkgs: intelPkgs: { }), ... }@args:
  let
    evalDarwinConfig =
      import "${nix-darwin}/eval-config.nix" { inherit (nixpkgs) lib; };

    # adapted from home-manager
    mkOutOfStoreSymlink = path:
      let
        pkgs = import nixpkgs { inherit system; };
        pathStr = toString path;
        name = home-manager.lib.hm.strings.storeFileName (baseNameOf pathStr);
      in pkgs.runCommandLocal name { }
      "ln -s ${nixpkgs.lib.escapeShellArg pathStr} $out";

    silliconBackportOverlay = new: old:
      let
        isSillicon = old.stdenv.hostPlatform.isDarwin
          && old.stdenv.hostPlatform.isAarch64;
        intel = "x86_64-darwin";
        intelSystem = mkDarwinSystem (args // { system = intel; });
        intelPkgs = intelSystem.pkgs;
      in if isSillicon then
        {
          # Common packages that are still not able to build on m1
          # inherit (intelPkgs) pandoc git-annex niv;

          # Marked as broken in aarch64-darwin
          inherit (intelPkgs)
            llvmPackages_6 llvmPackages_7 llvmPackages_8 llvmPackages_9
            llvmPackages_10;

        } // (silliconOverlay old intelPkgs)
      else
        { };

    # darwin-flake = pkgs: pkgs.writeScriptBin "darwin-flake" ''
    #   ${nixosConfiguration.system}/sw/bin/darwin-rebuild --flake ${
    #     mkOutOfStoreSymlink ./.
    #   } "''${@}"
    # '';

    nixpkgsOverlayModule = { config, pkgs, ... }: {
      nixpkgs.overlays = [
        (new: old:
          {
            # darwin-flake = darwin-flake pkgs;
          })
      ];
    };

    activationDiffModule = { config, ... }: {
      system.activationScripts.diffClosures.text = ''
        if [ -e /run/current-system ]; then
          echo "new configuration diff" >&2
          $DRY_RUN_CMD ${config.nix.package}/bin/nix store \
              --experimental-features 'nix-command' \
              diff-closures /run/current-system "$systemConfig" \
              | sed -e 's/^/[diff]\t/' >&2
        fi
      '';

      system.activationScripts.preActivation.text =
        config.system.activationScripts.diffClosures.text;
    };

    nixosConfiguration = evalDarwinConfig {
      inherit system;
      modules = [
        nix-darwin.darwinModules.flakeOverrides
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config = {
            localSystem = system;
            crossSystem = system;
          };
          nixpkgs.overlays = [ silliconBackportOverlay ];
        }
        nixpkgsOverlayModule
        activationDiffModule
      ] ++ nixosModules;
      inputs = {
        inherit nixpkgs;
        darwin = nix-darwin;
      };
      specialArgs = specialArgs {
        inherit mk-darwin-system;
        lib = nixpkgs.lib.extend (self: super: {
          inherit (home-manager.lib) hm;
          inherit mkOutOfStoreSymlink;
        });
      };
    };

    defaultPackage = nixosConfiguration.system;

    devShell = nixosConfiguration.pkgs.mkShell {
      packages = [ nixosConfiguration.system ];
    };

    defaultApp = flake-utils.lib.mkApp {
      drv = nixosConfiguration.pkgs.writeScriptBin "activate" ''
        ${defaultPackage}/sw/bin/darwin-rebuild activate --flake ${
          mkOutOfStoreSymlink ./.
        } "''${@}"
      '';
    };

    outputs = {
      inherit defaultApp defaultPackage devShell nixosConfiguration;
      inherit (nixosConfiguration) pkgs;
    };

  in outputs)
