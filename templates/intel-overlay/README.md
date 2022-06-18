### Intel `x86_64-darwin` pacakges example

This example shows how to create an overlay where you 
can select intel packages for use on your system.

A Nix Overlay lets you select or override packages definitions,
in this example, we use the `hello` package from `x86_64-darwin`
pkgs. Note that having intel packages might require you to have
Rosetta2 installed for running them on an `arm64-darwin`.


