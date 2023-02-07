{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    xclip
    discord

    betterlockscreen
    lm_sensors
  ];
}
