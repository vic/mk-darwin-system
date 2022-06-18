{
  description = "Development environments example";

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
        ({
          config,
          pkgs,
          ...
        }: {
          environment.systemPackages = with pkgs; [direnv];
        })

        ({
          config,
          pkgs,
          lib,
          ...
        }: let
          username = "yourUsername";

          scalaShell = pkgs.mkShell {packages = with pkgs; [sbt];};

          nodeShell = pkgs.mkShell {packages = with pkgs; [nodejs];};
        in {
          home-manager.users.${username} = {
            # The following function allows you to have a file `.envrc` with, eg.
            #
            # use nix-env scala
            #
            home.file.".config/direnv/lib/use_nix-env.sh".text = ''
              function use_nix-env() {
              	. "$HOME/.config/direnv/nix-envs/''${1}/env"
              }
            '';

            home.file.".config/direnv/nix-envs/scala".source =
              lib.mds.shellEnv scalaShell;
            home.file.".config/direnv/nix-envs/node".source =
              lib.mds.shellEnv nodeShell;
          };
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
