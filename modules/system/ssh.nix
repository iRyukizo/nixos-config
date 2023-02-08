{ config, lib, pkgs, ... }:

let
  inherit (builtins) any map;
  inherit (lib) mkEnableOption mkIf mkOption types foldl recursiveUpdate;
  recursiveMerge = foldl recursiveUpdate { };
  cfg = config.my.system.ssh;

  uakModule = types.submodule {
    options = {
      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          username (default: root)
        '';
      };

      keys = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          keys
        '';
      };
    };
  };
in
{
  options.my.system.ssh = {
    enable = mkEnableOption "Basic ssh configuration";
    usersAndKeys = mkOption {
      type = types.listOf uakModule;
      default = [ ];
      description = ''
        user and its associated keys
      '';
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        passwordAuthentication = false;
        permitRootLogin = if (any (x: x.user == "root") cfg.usersAndKeys) then "yes" else "no";
      };
    };

    users.users = recursiveMerge (map
      (u:
        { "${u.user}".openssh.authorizedKeys.keys = u.keys; }
      )
      cfg.usersAndKeys
    );
  };
}
