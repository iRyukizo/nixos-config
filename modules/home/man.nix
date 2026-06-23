{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.man;
in
{
  options.my.home.man = {
    enable = mkEnableOption "Home man configuration";
  };

  config.programs.man = mkIf cfg.enable {
    enable = true;
    generateCaches = true;
  };
}
