{ config, ... }:

{
  home-manager.users.ryuki = {
    my.home = {
        polybar = {
        enable = true;
        wlan = "wlp2s0";
        backlight = true;
        batteries = [
          {
            battery = "BAT0";
            adpater = "AC0";
            full-at = "100";
          }
        ];
      };
    };
  };
}
