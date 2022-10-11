{
  inputs = {
    # change tag or commit of nixpkgs for your system
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # change main to a tag o git revision
    mk-darwin-system.url = "github:vic/mk-darwin-system/main";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {mk-darwin-system, ...} @ inputs: let
    userName = "your-username";
    hostName = "your-hostname";

    darwinFlake = mk-darwin-system.mkFlake {
      inherit userName hostName inputs;
      flake = ./.;
    };
  in
    darwinFlake;
}
