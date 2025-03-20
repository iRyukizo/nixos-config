{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  home-manager.users.ryuki = {
    my.home = {
      polybar = {
        enable = true;
        wlan = "wlp2s0";
        eth = "enp0s20f0u2";
        backlight = true;
        batteries = [
          {
            battery = "BAT0";
            adpater = "AC0";
            full-at = "100";
          }
        ];
      };
      i3.enable = true;
      devenv.enable = true;
    };
  };

  my.packages = {
    core.enable = true;
    desktop.enable = true;
  };

  my.system = {
    type = "gui";
    networking = {
      hostname = "millenium";
      interfaces = [ "wlp2s0" "enp0s20f0u2" ];
      timeZone = "Asia/Taipei";
    };
    ssh.usersAndKeys = [
      {
        user = "ryuki";
        keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpSIW4gW755/FEFFV2rGvFwM8ixSMDHqEegEj0kPYpk" ];
      }
    ];
    xserver.layout = "gb";
  };

  services.logind.lidSwitch = "ignore";

  system.stateVersion = "23.05";

  console.keyMap = "uk";
}
