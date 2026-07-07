{ config, lib, ... }:

let
  inherit (lib) literalExpression mkDefault mkForce mkIf mkMerge mkOption types;
  cfg = config.my.system;
in
{
  imports = [
    ./file-system.nix
    ./docker.nix
    ./documentation.nix
    ./gui.nix
    ./locales.nix
    ./nix.nix
    ./secrets.nix
    ./sddm.nix
    ./users.nix
    ./xserver.nix
  ];

  options.my.system = {
    type = mkOption {
      type = types.enum [ "gui" "standard" "wsl" ];
      default = "gui";
      example = literalExpression ''gui'';
      description = ''
        Type of system (default: gui).
        Options: gui standard wsl
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.type == "gui") {
      my.system = {
        docker.enable = mkDefault true;
        documentation.enable = mkDefault true;
        fileSystem.enable = mkDefault true;
        gui.enable = mkDefault true;
        locales.enable = mkDefault true;
        nix.enable = mkDefault true;
        sddm.enable = mkDefault true;
        users.enable = mkDefault true;
        xserver.enable = mkDefault true;
      };
    })

    (mkIf (cfg.type == "standard") {
      my.system = {
        docker.enable = mkDefault true;
        documentation.enable = mkDefault true;
        fileSystem = {
          enable = mkDefault true;
          crypt = mkDefault false;
        };
        locales.enable = mkDefault true;
        nix.enable = mkDefault true;
        users.enable = mkDefault true;
      };
    })

    (mkIf (cfg.type == "wsl") {
      my.system = {
        docker.enable = mkDefault true;
        documentation.enable = mkDefault true;
        fileSystem = {
          enable = mkForce false;
          crypt = mkForce false;
        };
        locales.enable = mkDefault true;
        nix.enable = mkDefault true;
        users.enable = mkDefault true;
      };
    })
  ];
}
