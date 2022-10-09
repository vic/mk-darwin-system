# This is used to fallback some packages that are broken or
# will never be available on M1. NOTE: Using packages here
# will most likely require you to have Rosetta-2 installed.
intelPkgs:
self: super: let
  inherit (super) stdenv lib;
  isMacM1 = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  intelOverrides = {
    inherit (intelPkgs)
    llvmPackages_6
    llvmPackages_7
    llvmPackages_8
    llvmPackages_9
    llvmPackages_10
    ;
  };
in
if isMacM1 then intelOverrides else {}
