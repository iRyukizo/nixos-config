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
        wlan = "wlp58s0";
        eth = "enp57s0u1u3c2";
      };
      i3.enable = true;
      devenv.enable = true;
    };
  };

  my = {
    hardware = {
      inherit type;
      networking = {
        hostname = "arcadia";
        interfaces = [ "eno1" "wlp58s0" "enp57s0u1u3c2" ];
      };
    };

    packages = {
      core.enable = true;
      desktop.enable = true;
    };

    system = {
      inherit type;
    };

    services = {
      inherit type;
    };
  };

  system.stateVersion = "23.05";
}
