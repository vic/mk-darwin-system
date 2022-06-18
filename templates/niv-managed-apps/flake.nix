{
  description = "Minimal mkDarwinSystem example";

  inputs = {
    # change tag or commit of nixpkgs for your system
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # change main to a tag o git revision
    mk-darwin-system.url = "github:vic/mk-darwin-system/main";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    mk-darwin-system,
    ...
  }: let
    darwinFlakeOutput = mk-darwin-system.mkDarwinSystem.m1 {
      # Provide your nix modules to enable configurations on your system.
      #
      modules = [
        # System module
        ({
          config,
          pkgs,
          ...
        }: {
          environment.systemPackages = with pkgs; [nixfmt niv];
        })

        # User module
        ({
          pkgs,
          lib,
          ...
        }: {
          home-manager.users."yourUsername" = {
            home.packages = with pkgs; [KeyttyApp];

            # Link apps installed by home-manager.
            home.activation = {
              aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
                ln -sfn $genProfilePath/home-path/Applications "$HOME/Applications/HomeManagerApps"
              '';
            };
          };
        })

        ({lib, ...}: {
          nixpkgs.overlays = let
            nivSources = import ./nix/sources.nix;
          in [
            (new: old: {
              # You can provide an overlay for packages not available or that fail to compile on arm.
              inherit (lib.mds.intelPkgs) niv;

              # Provide apps managed by niv
              KeyttyApp = lib.mds.installNivDmg {
                name = "Keytty";
                src = nivSources.KeyttyApp;
              };
            })
          ];
        })
      ];
    };
  in
    darwinFlakeOutput
    // {
      # Your custom flake output here.
      darwinConfigurations."your-m1-hostname" =
        darwinFlakeOutput.darwinConfiguration.aarch64-darwin;
    };
}
