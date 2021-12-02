{ mkDarwinSystem, flake-utils, nixpkgs }: rec {
  systems = [ "aarch64-darwin" ];
  modules = [
    ({ pkgs, ... }: {
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

  apply = { nixosModules ? [ ], specialArgs ? nixpkgs.lib.id
    , silliconOverlay ? (silliconPkgs: intelPkgs: { }) }:
    flake-utils.lib.eachSystem systems (system:
      mkDarwinSystem {
        inherit system specialArgs silliconOverlay;
        nixosModules = nixosModules ++ modules;
      });
}
