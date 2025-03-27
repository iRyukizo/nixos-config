{ config, lib, ... }:

let
  inherit (lib) literalExpression mkDefault mkIf mkMerge mkOption types;
  cfg = config.my.system;
in
{
  imports = [
    ./bluetooth.nix
    ./file-system.nix
    ./docker.nix
    ./gui.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./secrets.nix
    ./sddm.nix
    ./users.nix
    ./xserver.nix
  ];

  options.my.system = {
    type = mkOption {
      type = types.enum [ "gui" "standard" ];
      default = "gui";
      example = literalExpression ''gui'';
      description = ''
        Type of system (default: gui).
        Options: gui standard
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.type == "gui") {
      my.system = {
        bluetooth.enable = mkDefault true;
        docker.enable = mkDefault true;
        fileSystem.enable = mkDefault true;
        gui.enable = mkDefault true;
        locales.enable = mkDefault true;
        networking.enable = mkDefault true;
        nix.enable = mkDefault true;
        sddm.enable = mkDefault true;
        users.enable = mkDefault true;
        xserver.enable = mkDefault true;
      };
    })

    (mkIf (cfg.type == "standard") {
      my.system = {
        docker.enable = mkDefault true;
        fileSystem = {
          enable = mkDefault true;
          crypt = mkDefault false;
        };
        locales.enable = mkDefault true;
        networking.enable = mkDefault true;
        nix.enable = mkDefault true;
        users.enable = mkDefault true;
      };
    })
  ];
}
