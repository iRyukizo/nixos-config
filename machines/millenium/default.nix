{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  networking = {
    hostName = "millenium";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    libinput.enable = true;
    enable = true;
    layout = "us";
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.ryuki = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    trustedUsers = [ "@wheel" ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    git
    networkmanagerapplet
    vim
    wget
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  system.stateVersion = "21.05";
}
