{self, nixpkgs, ...}@inputs:
let
  system = "aarch64-darwin";

  fromTemplate = name: let
    r = self.templates.${name}.path;
    f = import "${r}/flake.nix";
    x = f.outputs (inputs // { self = r; mk-darwin-system = self; });
  in x.checks.${system}.default;
in
{
  ${system} = builtins.mapAttrs (n: v: fromTemplate n) self.templates;
}
