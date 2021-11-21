{ config, ... }:

{
  home-manager.users.ryuki = {
    my.polybar = {
      enable = true;
      wlan = "wlp2s0";
      batteries = [
        {
          battery = "BAT0";
          adpater = "AC0";
          full-at = "100";
        }
      ];
    };
  };
}