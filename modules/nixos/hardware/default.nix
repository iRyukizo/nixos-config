{ config, lib, ... }:

let
  inherit (lib) literalExpression mkDefault mkIf mkMerge mkOption types;
  cfg = config.my.hardware;
in
{
  imports = [
    ./bluetooth.nix
    ./networking.nix
  ];

  options.my.hardware = {
    type = mkOption {
      type = types.enum [ "gui" "standard" ];
      default = "gui";
      example = literalExpression ''gui'';
      description = ''
        Type of hardware (default: gui).
        Options: gui standard
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.type == "gui") {
      my.hardware = {
        bluetooth.enable = mkDefault true;
        networking.enable = mkDefault true;
      };
    })

    (mkIf (cfg.type == "standard") {
      my.hardware = {
        networking.enable = mkDefault true;
      };
    })
  ];
}
