{ config, ... }: {
  system.activationScripts.diffClosures.text = ''
    if [ -e /run/current-system ]; then
      echo "new configuration diff" >&2
      $DRY_RUN_CMD ${config.nix.package}/bin/nix store \
          --experimental-features 'nix-command' \
          diff-closures /run/current-system "$systemConfig" \
          | sed -e 's/^/[diff]\t/' >&2
    fi
  '';

  system.activationScripts.preActivation.text =
    config.system.activationScripts.diffClosures.text;
}
