{ lib, ... }: {
  nixpkgs.overlays = [
    (new: old:
      let

        isSillicon = old.stdenv.hostPlatform.isDarwin
          && old.stdenv.hostPlatform.isAarch64;
        intelPkgs = lib.mds.intelPkgs;

      in if isSillicon then {
        # Common packages that are still not able to build on m1
        inherit (intelPkgs) niv;

        # Marked as broken in aarch64-darwin
        inherit (intelPkgs)
          llvmPackages_6 llvmPackages_7 llvmPackages_8 llvmPackages_9
          llvmPackages_10;

      } else
        { })

    # https://github.com/LnL7/nix-darwin/issues/417
    (new: old: {
      haskellPackages = old.haskellPackages.override {
        overrides = self: super:
          let
            workaround140774 = hpkg:
              with new.haskell.lib;
              overrideCabal hpkg (drv: { enableSeparateBinOutput = false; });
          in { niv = workaround140774 super.niv; };
      };
    })

  ];
}

