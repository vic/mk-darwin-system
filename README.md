# mk-darwin-system
[vic](http://twitter.com/oeiuwq)'s small utility to create a full ( [nixFlakes](https://nixos.wiki/wiki/Flakes) + [nix-darwin](https://daiderd.com/nix-darwin/) + [home-manager](https://github.com/nix-community/home-manager) )  [nixOS](https://nixos.org/) system.

## Getting Started

#### [Install `nixFlakes`](https://nixos.wiki/wiki/Flakes#Non-NixOS) on your system.

  In order to bootstrap your system, nixFlakes needs to be installed. 
  Also while bootstrapping the flake experimental commands need to be enabled.

  Be sure to enable flakes experimental commands by editing your `nix.conf` file or by
  using the `nix --experimental-features "nix-command flakes"` command.
  Following examples assume you already enabled these experimental features.


  Tip: If you create a file `$PWD/nix.conf` with the following content:

```conf
system = aarch64-darwin
extra-platforms = aarch64-darwin x86_64-darwin 
experimental-features = nix-command flakes
build-users-group = nixbld
```

  then you might `export NIX_CONF_DIR="$PWD"` and avoid typing long nix commands.

#### Create your darwinSystem flake:

```shell
mkdir my-system; cd my-system;
nix flake init -t github:vic/mk-darwin-system
```

#### Build and Activate your system

```shell
# Edit your generated flake.nix and customize your environment.

# Make sure your system builds
nix build --show-trace
ls result/ # if everything went ok, you'll have a darwin system in here, inspect it.

# Activate your system. For this to work, make sure your hostname is a nixosConfigurations attr.
nix run # same as calling: ./result/sw/bin/darwin-rebuild activate --flake .
```

## Cheat sheet.

- `nix run`
  the default app builds and activates your system.

- `nix build --show-trace`
  builds your system on `./result` and shows an stacktrace on error.

- `nix develop`
  enters an interactive shell with your system-environment packages enabled.

- `nix run '.#pkgs.aarch64-darwin.hello'`
  allows you to run apps directly.


## See Also
##### [minimal](templates/minimal)

`nix flake init -t 'github:vic/mk-darwin-system#minimal'`

The reference template you can edit to build your system upon.
##### [dev-envs](templates/dev-envs)

`nix flake init -t 'github:vic/mk-darwin-system#dev-envs'`

And example that shows how to setup `direnv` for *fast* *cached*
environments built along with your system. 
No need to use _lorri_ daemons. 
Loading the environment is as fast as sourcing a dump of environment variables.

##### [niv-managed-apps](templates/niv-managed-apps)

`nix flake init -t 'github:vic/mk-darwin-system#niv-managed-apps'`

An example showing how to install `.dmg` Apps while managing them with `niv`.
Links an home-manager installed Applications/ on user home.
###### [vix - Vic's Nix Environment](http://github.com/vic/vix)

vic's environment built using mkDarwinSystem.