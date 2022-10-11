{
  config,
  lib,
  pkgs,
  ...
}:
# for configurable home-manager modules see:
# https://github.com/nix-community/home-manager/blob/master/modules/modules.nix
{
  home.packages = with pkgs; [
    # Install nixpkgs
    exa

    # Install dmg applications versioned by niv from your `nix/sources.json` file.
    # See `nix develop -c niv show` on the root of your flake.
    nivApps.keytty-dmg
  ];

  # enable at least one shell. as for any other program, see customizable options at:
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/<program>.nix
  programs.fish.enable = true;
}
