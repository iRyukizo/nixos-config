{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.spotify;
in
{
  options.my.home.spotify = {
    enable = mkEnableOption "Home spotify configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
