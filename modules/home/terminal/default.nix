{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkDefault mkEnableOption mkIf mkOption types;
  cfg = config.my.home.terminal;
in
{
  imports = [
    ./urxvt
  ];

  options.my.home.terminal = {
    enable = mkEnableOption "terminal home configuration";
    terminal = mkOption {
      type = types.enum [ "urxvt" ];
      default = "urxvt";
      example = literalExpression ''urxvt'';
      description = ''
        terminal to use (default: urxvt).
        Options: urxvt
      '';
    };
  };

  config.my.home.terminal = mkIf cfg.enable {
    urxvt.enable = mkDefault (cfg.terminal == "urxvt");
  };
}
