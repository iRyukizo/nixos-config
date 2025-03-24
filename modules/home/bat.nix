{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.bat;
in
{
  options.my.home.bat = {
    enable = mkEnableOption "Home bat configuration";
  };

  config.programs.bat = mkIf cfg.enable {
      enable = true;
      config = {
        theme = "Nord";
        color = "always";

        pager = with config.programs.zsh.sessionVariables; "${PAGER}";
      };
  };
}
