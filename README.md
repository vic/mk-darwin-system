# mk-darwin-system
[vic](http://twitter.com/oeiuwq)'s small utility to create a full ( [nixFlakes](https://nixos.wiki/wiki/Flakes) + [nix-darwin](https://daiderd.com/nix-darwin/) + [home-manager](https://github.com/nix-community/home-manager) )  [nixOS](https://nixos.org/) system.

## Getting Started

#### [Install `nixFlakes`](https://nixos.wiki/wiki/Flakes#Non-NixOS) on your system.

  In order to bootstrap your system, nixFlakes needs to be installed
  and the flake experimental commands need to be enabled.

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

#### Customize, Build and Activate your system

```shell
# 1) first step is checking your system configuration is ok.
nix run . -- check

# 2) Edit your generated flake.nix and customize your environment.
# after editing your configuration, you might want to run step 1 again.

# 3) If everything went ok, you can switch to your new system using
nix run # same as: nix run . -- switch
```

Alternatively, or for debugging, you might want to build and activate manually with:

```shell
nix build # outputs your system into ./result/
./result/sw/bin/darwin-rebuild activate --flake .
# you might also be interested in ./result/activate and ./result/activate-user
```

## Cheat sheet.

- `nix run`
  the default app builds and activates your system.

- `nix develop`
  enters an interactive shell with your system-environment packages enabled.

- `nix run . -- --help`
  executes `darwin-rebuild` in the context of your flake.

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

##### [intel-overlay](templates/intel-overlay)

`nix flake init -t 'github:vic/mk-darwin-system#intel-overlay'`

An example of how to use `x86-64-darwin` packages even when your full
system is `arm64-darwin`.

###### [vix - Vic's Nix Environment](http://github.com/vic/vix)

vic's environment built using mkDarwinSystem.
