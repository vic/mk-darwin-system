{ config, lib, ... }:
with lib;
let
  cfg = config.programs.bash;
  username = config.home.username;

  sysBin = "/nix/var/nix/profiles/default/bin";
  usrBin =
    "/nix/var/nix/profiles/per-user/${username}/home-manager/home-path/bin";

in {
  config = mkIf cfg.enable (mkMerge [

    {
      programs.bash.profileExtra = ''
        case :$PATH: in
          *:${sysBin}:*)  ;;  # do nothing
          *) PATH=${sysBin}:$PATH ;;
        esac
        case :$PATH: in
          *:${usrBin}:*)  ;;  # do nothing
          *) PATH=${usrBin}:$PATH ;;
        esac
        export PATH
      '';
    }

  ]);
}
