
Create your system flake:

``` sh
nix new my-system --template github:vic/mk-darwin-system#minimal

cd my-system
```

Change the values of `hostName` and `userName` inside `flake.nix`.
Create files inside `nix/hostConfigurations` and `nix/homeConfigurations`.

See if everything is ok by building: `nix build`
Activate your system using: `nix run .`
