{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.codex;
in
{
  options.my.home.codex = {
    enable = mkEnableOption "Home codex configuration";
  };

  config = mkIf cfg.enable {
    programs.codex = {
      enable = true;
      settings = {
        check_for_update_on_startup = false;
      };
    };
    home.packages = with pkgs; [
      codex-acp
    ];
  };
}
