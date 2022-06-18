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
        # You might want to split them into separate files
        #  ./modules/host-one-module.nix
        #  ./modules/user-one-module.nix
        #  ./modules/user-two-module.nix
        # Or you can inline them here, eg.

        # for configurable nix-darwin modules see
        # https://github.com/LnL7/nix-darwin/blob/master/modules/module-list.nix
        ({
          config,
          pkgs,
          ...
        }: {
          environment.systemPackages = with pkgs; [nixfmt];
        })

        # for configurable home-manager modules see:
        # https://github.com/nix-community/home-manager/blob/master/modules/modules.nix
        {
          home-manager = {
            # sharedModules = []; # per-user modules.
            # extraSpecialArgs = {}; # pass aditional arguments to all modules.
          };
        }

        # An example of user environment. Change your username.
        ({
          pkgs,
          lib,
          ...
        }: {
          users.users."yourUsername".home = "/Users/yourUsername";
          home-manager.users."yourUsername" = {
            home.packages = with pkgs; [exa];

            # enable at least one shell. as for any other program, see customizable options at:
            # https://github.com/nix-community/home-manager/blob/master/modules/programs/<program>.nix
            programs.zsh.enable = true;
            # programs.fish.enable = true;
            # programs.bash.enable = true;

            # create some custom dot-files on your user's home.
            home.file.".config/foo".text = "bar";

            programs.git = {
              enable = true;
              userName = "Your Name";
              userEmail = "your@email.com";
            };
          };
        })

        # for configurable nixos modules see (note that many of them might be linux-only):
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/module-list.nix
        ({
          config,
          lib,
          ...
        }: {
          # You can provide an overlay for packages not available or that fail to compile on arm.
          #nixpkgs.overlays =
          #  [ (self: super: { inherit (lib.mds.intelPkgs) pandoc; }) ];

          # You can enable supported services (if they work on arm and are not linux only)
          #services.lorri.enable = true;
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
