{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.xdg;
in
{
  options.my.home.xdg = {
    enable = mkEnableOption "Home XDG configuration (personal directories)";
  };

  config = mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_PERSO_DIR = "$HOME/PERSO";
        XDG_EPITA_DIR = "$HOME/EPITA";
        XDG_ASSIST_DIR = "$HOME/EPITA/ASSISTANTS";
        XDG_LRDE_DIR = "$HOME/EPITA/LRDE";
        XDG_SCROT_DIR = "$HOME/Pictures/screenshots";
      };
    };
  };
}
