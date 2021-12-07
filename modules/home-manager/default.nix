{ config, ... }@args: {
  home-manager = {

    sharedModules = [ (import ./shared/init-shell-path.nix args) ];
  };
}
