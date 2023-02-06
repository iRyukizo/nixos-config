{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    python39
    arandr
    dconf
    dbus
    feh
    firefox
    git
    tree
    ranger
    networkmanagerapplet
    vim
    xfce.thunar
    evince
    wget
    playerctl
    pavucontrol
    brightnessctl
    pamixer
  ];

  my.packages.core.enable = true;

  services.dbus.enable = true;

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
