{ lib, ... }: {
  nixpkgs.overlays = [
    (new: old:
      let

        isSillicon = old.stdenv.hostPlatform.isDarwin
          && old.stdenv.hostPlatform.isAarch64;
        intelPkgs = lib.mds.intelPkgs;

      in if isSillicon then {
        # Common packages that are still not able to build on m1
        inherit (intelPkgs) pandoc;

        # Marked as broken in aarch64-darwin
        inherit (intelPkgs)
          llvmPackages_6 llvmPackages_7 llvmPackages_8 llvmPackages_9
          llvmPackages_10;

      } else
        { })
  ];
}

