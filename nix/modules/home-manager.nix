{
  config,
  inputs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      ./home-manager/init-shell-path.nix
    ];
  };
}
