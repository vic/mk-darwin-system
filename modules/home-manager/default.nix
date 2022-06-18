{config, ...} @ args: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [(import ./shared/init-shell-path.nix args)];
  };
}
