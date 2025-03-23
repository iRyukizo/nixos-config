{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.bluetooth;
in
{
  options.my.home.bluetooth = {
    enable = mkEnableOption "Home bluetooth configuration";
  };

  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
