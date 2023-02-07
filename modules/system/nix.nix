{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.nix;
in
{
  options.my.system.nix = {
    enable = mkEnableOption "Nix module configuration";
    gcCleanDuration = mkOption {
      type = types.str;
      default = "14d";
      description = ''
        remove files in nix-store old than value (default: 14d)
      '';
    };
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixStable;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than " + cfg.gcCleanDuration;
        persistent = true;
      };

      settings = {
        warn-dirty = true;
        experimental-features = ["nix-command" "flakes"];
        trusted-users = [ "@wheel" ];
      };
    };
  };
}
