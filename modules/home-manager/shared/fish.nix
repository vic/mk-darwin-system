{ config, lib, ... }:
with lib;
let
  cfg = config.programs.fish;
  username = config.home.username;

  sysBin = "/nix/var/nix/profiles/default/bin";
  usrBin =
    "/nix/var/nix/profiles/per-user/${username}/home-manager/home-path/bin";

in {
  config = mkIf cfg.enable (mkMerge [

    {
      programs.fish.loginShellInit = ''
        fish_add_path --move --prepend ${sysBin}
        fish_add_path --move --prepend ${usrBin}
      '';
    }

  ]);
}
