{ pkgs, ... }:

{
  networking = {
    hostName = "arcadia";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp58s0.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };
}
