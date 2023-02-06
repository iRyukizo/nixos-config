{ config, ... }:

{
  home-manager.users.ryuki = {
    my.polybar = {
      enable = true;
      wlan = "wlp3s0";
      eth = "enp60s0u1u3c2";
    };
    my.home = {
      fonts.enable = true;
    };
  };
}
