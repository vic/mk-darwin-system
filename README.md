
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

