{ config, lib, pkgs, inputs, ... }:
let
  hdiutil = config.lib.file.mkOutOfStoreSymlink "/usr/bin/hdiutil";

  dmgInstall = args: pkgs.stdenvNoCC.mkDerivation (args // {
    sourceRoot = ".";
    preferLocalBuild = true;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p mnt $out/Applications
      ${hdiutil} attach -readonly -mountpoint mnt $src
      cp -r mnt/*.app $out/Applications/
      ${hdiutil} detach -force mnt
    '';
  });

  apps = config.home.appsFromDmg;

  inherit (lib) mkIf mkOption length;
in
{
  options = {
    home.appsFromDmg = with lib.types; mkOption {
      type = listOf string;
      default = [];
      description = "List Niv managed installable dmg applications.";
    };
  };

  config = mkIf (length apps > 0) {
    home.packages = builtins.map (name:
      let dmg = inputs.nivSources.${name};
      in dmgInstall {
        src = dmg;
        inherit name;
        inherit (dmg) version;
      }
    ) apps;

    # Link apps installed by home-manager.
    home.activation = {
      aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ln -sfn $genProfilePath/home-path/Applications/* $HOME/Applications/
      '';
    };
  };

}
