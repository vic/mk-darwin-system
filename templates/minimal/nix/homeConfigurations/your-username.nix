{ config, lib, pkgs, ... }:

# for configurable home-manager modules see:
# https://github.com/nix-community/home-manager/blob/master/modules/modules.nix
{
  home.packages = with pkgs; [ exa ];

  # enable at least one shell. as for any other program, see customizable options at:
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/<program>.nix
  programs.fish.enable = true;
}
