# adapted from home-manager
{ lib, pkgs }:
path:
let
  pathStr = toString path;
  name = lib.hm.strings.storeFileName (baseNameOf pathStr);
in pkgs.runCommandLocal name { } "ln -s ${lib.escapeShellArg pathStr} $out"
