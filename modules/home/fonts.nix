{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.fonts;
in
{
  options.my.home.fonts = {
    enable = mkEnableOption "Home fonts configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      meslo-lgs-nf
      font-awesome
      siji
      font-awesome_5
      ryuki.system-san-francisco-font
      ryuki.san-francisco-display-regular-nerd-font
      ryuki.san-francisco-font
    ];

    fonts.fontconfig.enable = true;
  };
}
