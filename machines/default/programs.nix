{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    git
    networkmanagerapplet
    vim
    wget
  ];

  programs = {
    gnupg.agent.enable = true;
    ssh.startAgent = true;
    nm-applet.enable = true;
  };

  networking.networkmanager.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
