{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.bluetooth;
in
{
  options.my.system.bluetooth = {
    enable = mkEnableOption "Basic bluetooth configuration";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    services.blueman.enable = true;
  };
}
