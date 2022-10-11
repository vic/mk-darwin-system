{
  hostName,
  hostModules,
}: {
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  imports = hostModules;

  config = {
    _module.args.hostName = hostName;
    services.nix-daemon.enable = true;
    nix.extraOptions = builtins.readFile "${flake}/nix.conf";
  };
}
