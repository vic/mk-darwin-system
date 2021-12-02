{
  description = "Test flake";

  inputs = {
    mk-darwin-system.url = "path:/hk/mkDarwinSystem";

    template-minimal.url = "path:/hk/mkDarwinSystem/templates/minimal";
    template-minimal.inputs.mk-darwin-system.follows = "mk-darwin-system";

    template-apps.url = "path:/hk/mkDarwinSystem/templates/niv-managed-apps";
    template-apps.inputs.mk-darwin-system.follows = "mk-darwin-system";

    template-envs.url = "path:/hk/mkDarwinSystem/templates/dev-envs";
    template-envs.inputs.mk-darwin-system.follows = "mk-darwin-system";
  };

  outputs = { self, mk-darwin-system, template-minimal, template-apps
    , template-envs, ... }:
    let inherit (mk-darwin-system.inputs) nixpkgs;
    in {
      checks = {
        template-minimal.buildInputs =
          template-minimal.defaultPackage.aarch64-darwin;
        template-apps.buildInputs = template-apps.defaultPackage.aarch64-darwin;
        template-envs.buildInputs = template-envs.defaultPackage.aarch64-darwin;
      };
    };
}
