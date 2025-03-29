{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.my.services.fail2ban;
in
{
  options.my.services.fail2ban = {
    enable = mkEnableOption "Basic fail2an configuraiton";
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      maxretry = 3;

      bantime = "30m";

      bantime-increment = {
        enable = true;
        rndtime = "15m";
      };

      jails.DEFAULT.settings.findtime = "4h";
    };
  };
}
