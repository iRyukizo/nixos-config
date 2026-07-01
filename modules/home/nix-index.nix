{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.nix-index;
in
{
  options.my.home.nix-index = {
    enable = mkEnableOption "nix-index configuration";
  };

  config.programs.nix-index = mkIf cfg.enable {
    enable = true;
  };
}
