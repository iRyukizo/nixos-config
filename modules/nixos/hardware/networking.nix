{ config, lib, pkgs, ... }:

let
  inherit (builtins) map;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (lib.my) recursiveMerge;

  cfg = config.my.hardware.networking;
in
{
  options.my.hardware.networking = {
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
    wakeOnLanInterfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        wake on lan interfaces
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
      interfaces = recursiveMerge
        (map
          (int:
            { "${int}".useDHCP = true; }
          )
          cfg.interfaces
        ) //
      recursiveMerge (map
        (int:
          { "${int}".wakeOnLan.enable = true; }
        )
        cfg.wakeOnLanInterfaces
      );
    };

    time.timeZone = cfg.timeZone;
  };
}
