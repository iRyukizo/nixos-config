{ pkgs, ... }:

{
  networking = {
    hostName = "dragon";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "no";
    };
  };
}
