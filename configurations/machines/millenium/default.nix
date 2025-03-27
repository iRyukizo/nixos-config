{ pkgs, ... }:

let
  type = "gui";
in
{
  imports = [
    ./hardware.nix
  ];

  home-manager.users.ryuki = {
    my.home = {
      polybar = {
        enable = true;
        wlan = "wlp2s0";
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

  my = {
    hardware = {
      inherit type;
      networking = {
        hostname = "millenium";
        interfaces = [ "wlp2s0" ];
        timeZone = "Asia/Taipei";
      };
    };

    packages = {
      core.enable = true;
      desktop.enable = true;
    };

    system = {
      inherit type;
      xserver.layout = "gb";
    };

    services = {
      inherit type;
      ssh = {
        enable = true;
        usersAndKeys = [
          { user = "ryuki"; }
        ];
      };
    };
  };

  services.logind.lidSwitch = "ignore";

  system.stateVersion = "23.05";

  console.keyMap = "uk";
}
