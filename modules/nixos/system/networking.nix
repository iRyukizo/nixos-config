{ config, lib, pkgs, ... }:

let
  inherit (builtins) map;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (lib.my) recursiveMerge;

  cfg = config.my.system.networking;
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
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Paris";
      description = ''
        timezone (default: Europe/Paris)
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
        )
        cfg.interfaces
      );
    };

    time.timeZone = cfg.timeZone;
  };
}
