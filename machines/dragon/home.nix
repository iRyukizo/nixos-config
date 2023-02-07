{ config, ... }:

{
  home-manager.users.ryuki = {
    my.home = {
      polybar = {
        enable = true;
        wlan = "wlp3s0";
        eth = "enp60s0u1u3c2";
      };
      urxvt.enable = true;
      zsh.enable = true;
      dunst.enable = true;
      flameshot.enable = true;
      gtk.enable = true;
      xdg.enable = true;
    };
  };
}
