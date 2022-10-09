{self, ...}@inputs: {
    mkDarwinSystem = import ./mk-darwin-flake.nix inputs;

    templates = rec {
      default = minimal;

      minimal = {
        description = "mkDarwinSystem minimal example";
        path = ./../templates/minimal;
      };
    };

    checks = import ./flake-checks.nix inputs;

}
