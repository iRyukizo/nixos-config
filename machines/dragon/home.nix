{ config, ... }:

{
  home-manager.users.ryuki = {
    my.home = {
      polybar = {
        enable = true;
        wlan = "wlp3s0";
        eth = "enp60s0u1u3c2";
      };
      zsh.enable = true;
      xdg.enable = true;
      i3.enable = true;
    };
  };
}
