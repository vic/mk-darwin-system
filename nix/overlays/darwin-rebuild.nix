# A wrapper over darwin-rebuild that uses this flake.
darwin: flake: self: super: let
  inherit (self.pkgs) writeScriptBin;
  darwin-rebuild = writeScriptBin "darwin-rebuild" ''
    if [ -z "$*" ]; then
      exec ${darwin.profile}/sw/bin/darwin-rebuild --flake ${flake} switch
    else
      exec ${darwin.profile}/sw/bin/darwin-rebuild --flake ${flake} "''${@}"
    fi
  '';
in {
  inherit darwin-rebuild;
}
