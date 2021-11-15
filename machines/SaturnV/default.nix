{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  networking = {
    hostName = "SaturnV";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
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

  environment.systemPackages = with pkgs; [
    vim
    wget
    networkmanagerapplet
    firefox
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "21.05"; # Did you read the comment?
}
