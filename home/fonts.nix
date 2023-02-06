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
      own.system-san-francisco-font
      own.san-francisco-display-regular-nerd-font
      own.san-francisco-font
    ];

    fonts.fontconfig.enable = true;
  };
}
