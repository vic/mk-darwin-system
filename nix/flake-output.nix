{self, ...}@inputs: {
    mkDarwinSystem = import ./mk-darwin-flake.nix inputs;

    templates = rec {
      default = minimal;

      minimal = {
        description = "mkDarwinSystem minimal example";
        path = ./../templates/minimal;
      };
    };

    examples.minimal = self.mkDarwinSystem inputs {
      hostName = "your-hostname";
      hostModules = [ ./../templates/minimal/nix/hostConfigurations/your-hostname.nix ];
      userName = "your-username";
      userModules = [ ./../templates/minimal/nix/homeConfigurations/your-username.nix ];
    };

    checks.aarch64-darwin.minimal = self.examples.minimal.packages.aarch64-darwin.default;
}
