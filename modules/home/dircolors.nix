{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.dircolors;
in
{
  options.my.home.dircolors = {
    enable = mkEnableOption "Home dircolors configuration" // {
      enable = true;
    };
  };

  config = mkIf cfg.enable {
    programs.dircolors = {
      enable = true;
    };
  };
}
