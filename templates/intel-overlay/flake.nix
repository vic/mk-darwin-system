{
  description = "Example showing an intel overlay";

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
    # Sometimes you might want a handful of pacakges to explicitly be
    # selected from the `x86_64-darwin` packages instead of `arm64-darwin`.
    # Perhaps because they are not available or they fail to compile on arm.
    # NOTE: you might need to use rosetta in order to run intel binaries.
    #
    # You can read more about overlays here: https://nixos.wiki/wiki/Overlays
    intelPkgs = import nixpkgs {system = "x86_64-darwin";};
    intelOverlay = self: super: {inherit (intelPkgs) hello;};

    darwinFlakeOutput = mk-darwin-system.mkDarwinSystem.m1 {
      modules = [
        # Make the overlay available on all configuration modules.
        # This is useful when importing config from other files that wont have
        # intelOverlay in scope.
        {
          nixpkgs.overlays = [intelOverlay];
        }

        # Now add the intel hello pacakge to any user or system packages.
        ({
          pkgs,
          lib,
          ...
        }: {
          users.users."yourUsername".home = "/Users/yourUsername";
          home-manager.users."yourUsername" = {
            # Since we added the intelOverlay to our modules above, `hello` will
            # refer to the intel pkg. You could also explicitly use `intelPkgs.hello`.
            home.packages = with pkgs; [hello];
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

      # You can also expose your overlays for other flakes to use.
      overlays.default = intelOverlay;

      # Also you might want to export intelPkgs as a global attribute on your flake.
      # `nix run . 'intelPkgs.hello'` # You can run packages directly.
      inherit intelPkgs;
    };
}
