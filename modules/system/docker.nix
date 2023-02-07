{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.docker;
in
{
  options.my.system.docker= {
    enable = mkEnableOption "Basic docker configuration";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}
