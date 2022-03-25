# Changelog

## Unreleased

* Add Makefile ([12a7366](https://www.github.com/vic/mk-darwin-system/commit/12a7366))

* Fix deprecations for default devShell and default package. ([992d35c](https://www.github.com/vic/mk-darwin-system/commit/992d35c)) ([83d20f4](https://www.github.com/vic/mk-darwin-system/commit/83d20f4))


* Remove workaround for niv since it now builds on M1 ([1b197ac](https://www.github.com/vic/mk-darwin-system/commit/1b197ac))

* Added an example to set your home directory #11 


## [0.2.0](https://www.github.com/vic/mk-darwin-system/compare/v0.1.0...v0.2.0) (2021-12-07)


### ⚠ BREAKING CHANGES

* By using `darwinConfiguration` instead of `nixosConfiguration` we are able to use `darwin-rebuild --flake .` since nix-darwin expects the first attribute path and not the second.

### Features

* useGlobalPkgs, useUserPackages always true ([9a32b5b](https://www.github.com/vic/mk-darwin-system/commit/9a32b5b4077a87e1318624c030e4309433168da7))


### Bug Fixes

* Correct user and system PATH on shell init ([ab390ae](https://www.github.com/vic/mk-darwin-system/commit/ab390aea27d1230a6d204b0be1cd40755b2f1655))
* Flake should expose `darwinConfiguration` ([ba4bce1](https://www.github.com/vic/mk-darwin-system/commit/ba4bce1a02358c94adad82461ea45318501a0915))

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
