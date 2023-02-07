{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    xclip
    discord
    scrot

    betterlockscreen
    lm_sensors
  ];
}
