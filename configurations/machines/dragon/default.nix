{ config, pkgs, ... }:

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

  my.packages = {
    core.enable = true;
  };

  my.system = {
    type = "standard";
    networking = {
      hostname = "dragon";
      interfaces = [ "eno1" "wlp3s0" ];
      wakeOnLanInterfaces = [ "eno1" ];
      timeZone = "Asia/Taipei";
    };
    ssh.usersAndKeys = [
      { user = "ryuki"; }
    ];
  };

  system.stateVersion = "23.05";
}
