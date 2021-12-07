#!/usr/bin/env bash
set -ex

function test_template {
  nix develop -c darwin-rebuild --flake "$PWD/templates/$1#your-m1-hostname" --override-input mk-darwin-system $PWD check
}

test_template minimal
test_template dev-envs
test_template niv-managed-apps

