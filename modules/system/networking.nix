{ config, lib, pkgs, ... }:

let
  inherit (builtins) map;
  inherit (lib) mkEnableOption mkIf mkOption types foldl recursiveUpdate;
  cfg = config.my.system.networking;
  recursiveMerge = foldl recursiveUpdate { };
in
{
  options.my.system.networking = {
    enable = mkEnableOption "Networking configuration";
    hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = ''
        hostname (default: nixos)
      '';
    };
    interfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        all interfaces to open
      '';
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostname;
      useDHCP = false;
      networkmanager.enable = true;
      interfaces = recursiveMerge (map
        (int:
          { "${int}".useDHCP = true; }
        ) cfg.interfaces
      );
    };

    time.timeZone = "Europe/Paris";
  };
}
