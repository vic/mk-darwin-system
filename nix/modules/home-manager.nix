{ config, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      ./home-manager/init-shell-path.nix
      # Allows access to system-config while evaluation user-level modules.
      { config._module.args.system-config = config; }
    ];
  };
}
