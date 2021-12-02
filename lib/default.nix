{ nixpkgs, ... }:
{ pkgs, lib, ... }:
let intelPkgs = nixpkgs.legacyPackages.x86_64-darwin;
in {

  inherit intelPkgs;

  mkOutOfStoreSymlink = import ./out-symlink.nix { inherit pkgs lib; };
  installNivDmg = import ./install-dmg.nix { inherit pkgs lib; };
  shellEnv = import ./shell-env.nix { inherit pkgs; };

}
