{ config, ...}:

{
  nixpkgs.overlays = [
    (import ./../overlays/darwin-rebuild.nix config.system)
  ];
}
