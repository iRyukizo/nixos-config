{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkEnableOption mkIf mkOption optional types;
  cfg = config.my.home.fonts;
in
{
  options.my.home.fonts = {
    enable = mkEnableOption "Home fonts configuration";
    type = mkOption {
      type = types.enum [ "standard" "darwin" "remote" ];
      default = "standard";
      example = literalExpression ''standard'';
      description = ''
        Type of system (default: standard).
        Options: standard darwin remote
      '';
    };
  };

  config = mkIf (cfg.enable && (cfg.type != "remote")) {
    home.packages = with pkgs; [
      font-awesome
      lxgw-wenkai-tc
      ryuki.noto-fonts-cjk-sans-tc
    ] ++ optional (cfg.type == "standard") [
      font-awesome_5
      siji
      ryuki.system-san-francisco-font
      ryuki.san-francisco-display-regular-nerd-font
      ryuki.san-francisco-font
    ];

    fonts.fontconfig.enable = true;
  };
}
