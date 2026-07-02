{ config, lib, pkgs, standaloneHome, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.man;
in
{
  options.my.home.man = {
    enable = mkEnableOption "Home man configuration";
  };

  config = {
    programs.man = mkIf cfg.enable {
      enable = true;
      package = pkgs.man;
      generateCaches = true;
    };

    home.packages = with pkgs; mkIf standaloneHome [
      man-pages
      man-pages-posix
    ];
  };
}
