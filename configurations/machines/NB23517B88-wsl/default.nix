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
      vim.options.xc8Support = true;
    };
  };


  wsl = {
    enable = true;
    defaultUser = "ryuki";
  };

  boot.isContainer = true;

  networking = {
    hostName = "NB23517B88-wsl";
  };
  time.timeZone = "Asia/Taipei";

  my = {
    packages = {
      core.enable = true;
    };

    hardware = {
      inherit type;
    };

    system = {
      inherit type;

      # Set a different uid for user in case of multiple distribution on WSL.
      # https://github.com/microsoft/WSL/issues/13985
      # users.uid = 1100;
    };

    services = {
      inherit type;
    };
  };

  system.stateVersion = "26.05";
}
