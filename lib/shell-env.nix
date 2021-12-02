{ pkgs }:
shell:
pkgs.runCommandLocal "${shell.name}-shell-env.bash" {
  shell_input_derivation = shell.inputDerivation;
} (builtins.readFile ./shell-env.bash)
