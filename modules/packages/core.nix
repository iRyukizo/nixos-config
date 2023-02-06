{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.packages.core;
in
{
  options.my.packages.core = {
    enable = mkEnableOption "Core packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      htop
      man-pages
      man-pages-posix
      unzip
      wget
      zip
    ];
  };
}
