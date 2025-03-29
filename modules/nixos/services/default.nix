{ config, lib, ... }:

let
  inherit (lib) literalExpression mkDefault mkIf mkMerge mkOption types;
  cfg = config.my.services;
in
{
  imports = [
    ./fail2ban.nix
    ./ssh.nix
  ];

  options.my.services = {
    type = mkOption {
      type = types.enum [ "gui" "standard" ];
      default = "gui";
      example = literalExpression ''gui'';
      description = ''
        Type of service (default: gui).
        Options: gui standard
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.type == "gui") {
      my.services = {
        ssh.enable = mkDefault false;
        fail2ban.enable = mkDefault false;
      };
    })
    (mkIf (cfg.type == "standard") {
      my.services = {
        ssh.enable = mkDefault true;
        fail2ban.enable = mkDefault true;
      };
    })
  ];
}
