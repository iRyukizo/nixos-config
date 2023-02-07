{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.flameshot;
in
{
  options.my.home.flameshot = {
    enable = mkEnableOption "Home flameshot configuration";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          savePath = "/home/ryuki/Pictures/screenshots";
        };
      };
    };
  };
}
