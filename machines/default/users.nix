{ pkgs, ... }:

{
  users.users.ryuki = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
}
