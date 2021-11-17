{ pkgs, ... }:

{
  networking = {
    hostName = "millenium";
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };
}
