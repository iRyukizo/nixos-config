{ config, ... }:

{
  home-manager.users.ryuki = {
    my.home = {
        polybar = {
        enable = true;
        wlan = "wlp58s0";
        eth = "eno1";
      };
    };
  };
}
