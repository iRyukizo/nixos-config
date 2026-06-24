{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
  };

  cfg = config.my.system.sddm;
in
{
  options.my.system.sddm = {
    enable = mkEnableOption "Basic sddm configuration";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        custom-sddm-astronaut
      ];
      settings = {
        Theme = {
          Current = "sddm-astronaut-theme";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      custom-sddm-astronaut
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
      kdePackages.qtmultimedia
    ];
  };
}
