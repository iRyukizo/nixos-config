{ pkgs, ... }:

{
  networking = {
    hostName = "mothership";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp58s0.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGAGVcTHJvq1wyauyhg2l8aTN5jWkpAkIX+p6qlqa/86" ];
}
