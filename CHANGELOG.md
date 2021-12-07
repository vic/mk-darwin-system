# Changelog

## [0.1.0](https://www.github.com/vic/mk-darwin-system/compare/444fd6c...v0.1.0)

### Features

* first minor release.
* mkDarwinSystem does not takes `hostName` anymore. User must expose a `nixosConfiguration.${hostName}` on their flake.
* mkDarwinSystem no longer takes `specialArgs`, `flakeOutputs`, `silliconOverlay` functions.
* examples are now flake templates usable with `nix flake init -t`.
* simplify documentation and add links to different templates.
* expose our library helper functions at `lib.mds`.
* expose `lib.mds.shellEnv` that creates an environment dump from a `pkgs.mkShell`.
* added `templates/dev-envs/flake.nix` that setups a couple of `direnv` enabled shell environments using `lib.mds.shellEnv`.
* expose `lib.mds.installNivDmg` which uses `hdiutil` to mount/unmount an dmg image.
* added `templates/niv-managed-apps/flake.nix` as an example of how to install dmg MacOS applications being managed by niv.
* `templates/minimal/flake.nix` is more annotated now, having links to configurable modules so people can explore from there.
* added a single `tests/flake.nix` to aggregate all templates and test if they are buildable.
* Haskell packages removed from intelOverlay since nixpkgs#126195 has been fixed.
* intelOverlay now includes `pandoc` since some of it's dependencies fail on m1. seems to be the same with `niv`


## [0.0.0](https://www.github.com/vic/mk-darwin-system/compare/8bf7b851...444fd6c)


### Features

* mkDarwinSystem initial implementation.
* show diff between configurations when activating a new system.
* temporarily use haskell packages from intel since they wont compile on m1. Until [nixpkgs#126195](https://github.com/NixOS/nixpkgs/pull/126195) gets merged.
* add basic example at `examples/minimal/flake.nix`
* usage documentation.