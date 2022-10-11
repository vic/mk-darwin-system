{inputs, ...}: {
  nixpkgs.overlays = [
    (import ./../overlays/intel-pkgs.nix inputs.nixpkgs.legacyPacakges.x86_64-darwin)
  ];
}
