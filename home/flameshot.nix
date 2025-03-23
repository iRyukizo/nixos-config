{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.flameshot;
in
{
  options.my.home.flameshot = {
    enable = mkEnableOption "Home flameshot configuration";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          contrastOpacity = 173;
          contrastUiColor = "#d1d1d1";
          drawColor = "#00ff00";
          uiColor = "#383C4A";
          saveAfterCopy = true;
          savePath = "${config.home.homeDirectory}/Pictures/screenshots";
          uploadWithoutConfirmation = true;
          useJpgForClipboard = true;
        };
      };
    };
  };
}
