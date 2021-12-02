{ pkgs, lib, ... }:
let hdiutil = lib.mds.mkOutOfStoreSymlink "/usr/bin/hdiutil";
in { name, src, ... }@args:
pkgs.stdenvNoCC.mkDerivation (args // {
  sourceRoot = ".";
  preferLocalBuild = true;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p mnt $out/Applications
    ${hdiutil} attach -readonly -mountpoint mnt $src
    cp -r mnt/*.app $out/Applications/
    ${hdiutil} detach -force mnt
  '';
})
