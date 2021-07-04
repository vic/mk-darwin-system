# mk-darwin-system
[vic](http://twitter.com/oeiuwq)'s small utility to create a full ( [nixFlakes](https://nixos.wiki/wiki/Flakes) + [nix-darwin](https://daiderd.com/nix-darwin/) + [home-manager](https://github.com/nix-community/home-manager) )  [nixOS](https://nixos.org/) system.

## Prerequisites

Install `nixFlakes` on your system and create a flake based on the examples bellow (or just cd into `examples/minimal`).

Use `nix build` and inspect `./result`. If all is good, activate your system with `nix run`.

## Usage

Follow one of the examples bellow to create a flake that creates a nixos configuration.

For example, using the `examples/minimal`, you can see that `mk-darwin-system` produces a flake with
the following outputs: 

  - `nixosConfigurations.aarch64-darwin.${hostName}`: The full nixos configuration for the configured host.
  - `defaultPackage`: The full darwin system derivation. Use `nix build` to see it in `./result`
  - `defaultApp`: An app that activates the darwin system. Use `nix run` to activate your system.
  - `devShell`: An environment containing system packages. Use `nix develop` to enter a shell with the system environment; or `nix print-dev-env` with something like [direnv](https://direnv.net/) to load the environment in your current shell.
  - `pkgs`: A set of all packages available in the nixos system. ie, You can build `nix build '.#pkgs.aarch64-darwin.hello'`.
  - `packages`: A set of exposed packages (shown by `nix flake show`). ie, You can build `nix build '.#hello'`

```
> cd examples/minimal
> nix flake show
git+file:///hk/mk-darwin-system?dir=examples%2fminimal
├───defaultApp
│   └───aarch64-darwin: app
├───defaultPackage
│   └───aarch64-darwin: package 'darwin-system-21.11.20210704.4e82100+darwin4.007d700'
├───devShell
│   └───aarch64-darwin: development environment 'nix-shell'
├───nixosConfigurations
│   └───aarch64-darwin: NixOS configuration
├───packages
│   └───aarch64-darwin
│       └───hello: package 'hello-2.10'
└───pkgs: unknown
```

### Options

The provided `mkDarwinSystem` can take the following options:

```nix
mkDarwinSystem {
  system   = "aarch64-darwin";
  hostName = "example";            # hostName used to bind darwinConfigurations.${system}.${hostName}
  nixosModules = [];               # a list of modules further customize your darwin system.
  silliconOverlay =                # a function for selecting intelPkgs for packages not available yet in M1, eg:
    (silliconPkgs: intelPkgs: {}); # (silliconPkgs: intelPkgs: { inherit (intelPkgs) haskell haskellPackages; })
  flakeOutputs =                   # a function to customize what's exported from your system flake.
    ({
      defaultApp, defaultPackage, devShell, pkgs, nixosConfigurations.${hostName}
    }@outputs = outputs)
}
```

### Examples
##### [minimal](examples/minimal)
###### [vix - Vic's Nix Environment](http://github.com/vic/vix)
