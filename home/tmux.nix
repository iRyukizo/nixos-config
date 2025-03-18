{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.tmux;
in
{
  options.my.home.tmux = {
    enable = mkEnableOption "Home tmux configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      terminal = "screen-256color";
    };
  };
}
