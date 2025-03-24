{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.sddm;
in
{
  options.my.system.sddm = {
    enable = mkEnableOption "Basic sddm configuration";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = "Nordic";
    };

    environment.systemPackages = [
      pkgs.nordic.sddm
    ];
  };
}
