{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.xdg;
in
{
  options.my.home.xdg = {
    enable = mkEnableOption "Home XDG configuration (personal directories)";
    userDirsEnable = mkEnableOption "Home XDG user dirs configuration";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = mkIf cfg.userDirsEnable {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_WORKSPACE_DIR = "$HOME/Workspace";
          XDG_PROJECTS_DIR = "$HOME/Workspace/Projects";
          XDG_PERSONAL_DIR = "$HOME/Workspace/Personal";
          XDG_SCROT_DIR = "$HOME/Pictures/screenshots";
        };
      };
    };
  };
}
