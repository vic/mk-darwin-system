{ config, lib, ... }:
with lib;
let
  cfg = config.programs.zsh;
  username = config.home.username;

  sysBin = "/nix/var/nix/profiles/default/bin";
  usrBin =
    "/nix/var/nix/profiles/per-user/${username}/home-manager/home-path/bin";
in {
  config = mkMerge [

    (mkIf cfg.enable {
      programs.zsh.initExtraFirst = ''
        export -U PATH=${sysBin}''${PATH:+:$PATH}
        export -U PATH=${usrBin}''${PATH:+:$PATH}
      '';
    })

  ];
}
