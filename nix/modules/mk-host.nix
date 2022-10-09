{ hostName, hostModules }:
{ config, lib, pkgs, ... }:
{
  config = {
    _module.args.hostName = hostName;
  };
  imports = hostModules;
}
