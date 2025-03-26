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
    };
    ssh.usersAndKeys = [
      { user = "ryuki"; }
    ];
  };

  system.stateVersion = "23.05";
}
