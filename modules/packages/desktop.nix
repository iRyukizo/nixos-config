{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.packages.desktop;
in
{
  options.my.packages.desktop = {
    enable = mkEnableOption "Core packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      arandr
      chromium
      discord
      evince
      feh
      firefox
      stack
      teams
      vlc
    ];
  };
}
