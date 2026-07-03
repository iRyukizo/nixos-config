{ ... }:

let
  type = "wsl";
in
{
  imports = [ ];

  home-manager.users.ryuki = {
    my.home = {
      devenv = {
        enable = true;
        type = "wsl";
      };
    };
  };

  # Set a different uid for user in case of multiple distribution on WSL.
  # https://github.com/microsoft/WSL/issues/13985
  # uid = 1100;
  # users.users.ryuki.uid = 1100;

  wsl = {
    enable = true;
    defaultUser = "ryuki";
  };

  boot.isContainer = true;

  networking = {
    hostName = "NB23517B88-wsl";
  };

  my = {
    packages = {
      core.enable = true;
    };

    hardware = {
      inherit type;
      networking = {
        hostname = "NB23517B88-wsl";
        timeZone = "Asia/Taipei";
      };
    };

    system = {
      inherit type;
    };

    services = {
      inherit type;
    };
  };

  system.stateVersion = "26.05";
}
