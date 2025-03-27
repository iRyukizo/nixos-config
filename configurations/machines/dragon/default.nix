{ config, pkgs, ... }:

let
  type = "standard";
in
{
  imports = [
    ./hardware.nix
  ];

  home-manager.users.ryuki = {
    my.home = {
      devenv = {
        enable = true;
        type = "remote";
      };
    };
  };

  my = {
    packages = {
      core.enable = true;
    };

    hardware = {
      inherit type;
      networking = {
        hostname = "dragon";
        interfaces = [ "eno1" "wlp3s0" ];
        wakeOnLanInterfaces = [ "eno1" ];
        timeZone = "Asia/Taipei";
      };
    };

    system = {
      inherit type;
    };

    services = {
      inherit type;
      ssh.usersAndKeys = [
        { user = "ryuki"; }
      ];
    };
  };

  system.stateVersion = "23.05";
}
