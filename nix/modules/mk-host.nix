{ hostName }:
{ config, lib, pkgs, ... }:
{
  config = {
    _module.args.hostName = hostName;
  };
  imports = [ "${./../hostConfigurations}/${hostName}.nix" ];
}
