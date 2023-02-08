{ pkgs, ... }:

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

  my.packages = {
    core.enable = true;
    desktop.enable = true;
  };

  my.system = {
    enableDefault = true;
    networking = {
      hostname = "arcadia";
      interfaces = [ "eno1" "wlp58s0" "enp57s0u1u3c2" ];
    };
  };

  system.stateVersion = "23.05";
}
