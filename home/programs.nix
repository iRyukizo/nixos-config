{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    discord

    betterlockscreen
    lm_sensors
  ];
}
