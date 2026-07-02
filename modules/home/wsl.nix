{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.my.home.wsl;
in
{
  options.my.home.wsl = {
    enable = mkEnableOption "WSL configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnumake
      tree
    ];
  };
}
