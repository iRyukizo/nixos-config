{ config, ... }:

{
  home-manager.users.ryuki = {
    my.polybar = {
      enable = true;
      wlan = "wlp58s0";
      eth = "eno1";
    };
  };
}
