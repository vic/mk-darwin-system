# A wrapper over darwin-rebuild that uses this flake.
darwin:
self: super:
let
  inherit (self.pkgs) writeScriptBin;
  darwin-rebuild = writeScriptBin "darwin-rebuild" ''
  if [ -z "$*" ]; then
    exec ${darwin.profile}/sw/bin/darwin-rebuild --flake ${./../..} switch
  else
    exec ${darwin.profile}/sw/bin/darwin-rebuild --flake ${./../..} "''${@}"
  fi
  '';
in
{
  inherit darwin-rebuild;
}
