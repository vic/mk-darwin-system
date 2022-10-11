{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) nivSources;
  hm = pkgs.callPackage "${inputs.home-manager}/modules/files.nix" {
    lib = pkgs.lib // inputs.home-manager.lib;
  };
  hdiutil = hm.config.lib.file.mkOutOfStoreSymlink "/usr/bin/hdiutil";
in {
  nixpkgs.overlays = [
    (import ./../overlays/niv-managed-dmg-apps.nix {
      inherit nivSources hdiutil;
    })
  ];
}
