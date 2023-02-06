{ config, ... }:

{
  home-manager.users.ryuki = {
    my.home = {
      polybar = {
        enable = true;
        wlan = "wlp3s0";
        eth = "enp60s0u1u3c2";
      };
      fonts.enable = true;
      ranger.enable = true;
    };
  };
}
