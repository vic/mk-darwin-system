{ config, flake, ...}:

{
  nixpkgs.overlays = [
    (import ./../overlays/darwin-rebuild.nix config.system flake)
  ];
}
