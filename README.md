## Deprecation Notice

NOTE: This repo is now read-only, since I (vic) am no longer using MacOS since early 2023. You can still find a much more maintained and better alternative at 
https://github.com/srid/nixos-flake


<details>
  <summary>Old README</summary>
  




## Usage

* Create your system flake:

``` sh
nix flake new my-system --template github:vic/mk-darwin-system#minimal

cd my-system
git init
git add .
```

* Change the values of `hostName` and `userName` inside `flake.nix`.

* Create files inside `nix/hostConfigurations` and `nix/homeConfigurations`.

* See if everything is ok by running: `nix flake check`

* Activate your system running: `nix run`


## Examples

* [vic](http://twitter.com/oeiuwq)'s own [M1 system](http://github.com/vic/vix) from which
  this library was extracted.
  
* yours, [send a pull-request](http://github.com/vic/mk-darwin-system/pulls).

## References

* Files inside `nix/hostConfigurations` can set any [nix-darwin option](https://daiderd.com/nix-darwin/manual/index.html#sec-options).
* Files inside `nix/homeConfigurations` can set any [home-manager option](https://nix-community.github.io/home-manager/options.html).
* Using [nix-darwin brew options](https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.enable) it's possible to install 
  packages from [Homebrew](https://brew.sh/) taps, casks, [Mac App Store Apps](https://www.apple.com/app-store/) and Docker containers. Note that these would be installed as system packages.
* When your nix files get bigger you can split them using conventional [NixOS Modules](https://nixos.wiki/wiki/NixOS_modules) `imports = []`.
* Be sure to also check this nice [Nix language tutorial](https://nix.dev/tutorials/nix-language)



</details>
