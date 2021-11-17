{ pkgs, ... }:

{
  services.xserver = {
    libinput.enable = true;
    enable = true;
    # layout = "us"; # "us" is default
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };
}
