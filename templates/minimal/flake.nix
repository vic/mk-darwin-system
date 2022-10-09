{
  inputs = {
    # change tag or commit of nixpkgs for your system
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # change main to a tag o git revision
    mk-darwin-system.url = "github:vic/mk-darwin-system/main";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
  let
    userName = "your-username";
    hostName = "your-hostname";
    userModules = [ ./nix/homeConfigurations/${userName}.nix ];
    hostModules = [ ./nix/hostConfigurations/${hostName}.nix ];

    darwinFlake = inputs.mk-darwin-system.mkDarwinSystem inputs {
      inherit userName hostName userModules hostModules;
    };
  in darwinFlake;
}
