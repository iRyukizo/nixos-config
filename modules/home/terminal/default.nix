{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkDefault mkEnableOption mkIf mkOption types;
  cfg = config.my.home.terminal;
in
{
  imports = [
    ./alacritty
    ./urxvt
  ];

  options.my.home.terminal = {
    enable = mkEnableOption "terminal home configuration";
    terminal = mkOption {
      type = types.enum [ "alacritty" "urxvt" ];
      default = "alacritty";
      example = literalExpression ''alacritty'';
      description = ''
        terminal to use (default: urxvt).
        Options: alacritty urxvt
      '';
    };
  };

  config.my.home.terminal = mkIf cfg.enable {
    alacritty.enable = mkDefault (cfg.terminal == "alacritty");
    urxvt.enable = mkDefault (cfg.terminal == "urxvt");
  };
}
