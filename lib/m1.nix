{
  mkDarwinSystem,
  flake-utils,
  nixpkgs,
}: rec {
  m1Systems = ["aarch64-darwin"];
  m1Modules = [
    ({pkgs, ...}: {
      services.nix-daemon.enable = true;
      nix.package = pkgs.nixFlakes;
      nix.extraOptions = ''
        system = aarch64-darwin
        extra-platforms = aarch64-darwin x86_64-darwin
        experimental-features = nix-command flakes
        build-users-group = nixbld
      '';
    })
  ];

  apply = {
    modules ? [],
    flakePath ? ".",
  }:
    flake-utils.lib.eachSystem m1Systems (system:
      mkDarwinSystem {
        inherit system flakePath;
        modules = m1Modules ++ modules;
      });
}
