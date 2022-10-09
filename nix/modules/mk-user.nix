{ userName, userHome, userModules }:
{ config, ...}@args:
{
  users.users."${userName}".home = userHome;
  home-manager.users."${userName}" = {
    imports = userModules;
    config = {
     home.stateVersion = "22.05";

     home.file.".config/nix/nix.conf".text = ''
     experimental-features = nix-command flakes
     extra-platforms = aarch64-darwin x86_64-darwin
     '';
    };
  };
}
