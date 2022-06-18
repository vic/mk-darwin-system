{config, ...}:
# system config.
let
  sysBin = "${config.system.profile}/sw/bin";
in
  {
    config,
    lib,
    ...
  }:
  # per-user config.
  let
    username = config.home.username;
    usrBin = "${config.home.profileDirectory}/bin";
  in
    with lib; {
      config = mkMerge [
        (mkIf config.programs.bash.enable {
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
        })

        (mkIf config.programs.zsh.enable {
          programs.zsh.initExtraFirst = ''
            export -U PATH=${sysBin}''${PATH:+:$PATH}
            export -U PATH=${usrBin}''${PATH:+:$PATH}
          '';
        })

        (mkIf config.programs.fish.enable {
          programs.fish.loginShellInit = ''
            fish_add_path --prepend --global ${sysBin} ${usrBin}
          '';
        })
      ];
    }
