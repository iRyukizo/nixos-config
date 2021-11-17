{ pkgs, ... }:

{
  users.users.ryuki = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
}
