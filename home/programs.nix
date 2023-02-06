{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    xclip
    discord
    scrot

    faba-icon-theme
    gnome-icon-theme
    betterlockscreen
    lm_sensors
  ];
}
