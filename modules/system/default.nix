{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge;
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
    ./ssh.nix
    ./users.nix
    ./xserver.nix
  ];

  options.my.system = {
    enableDefault = mkEnableOption "Enable all default options";
    enableBasic = mkEnableOption "Enable everything except graphic interface";
  };

  config = mkMerge [
    (mkIf cfg.enableDefault {
      my.system = {
        bluetooth.enable = mkDefault true;
        docker.enable = mkDefault true;
        fileSystem.enable = mkDefault true;
        gui.enable = mkDefault true;
        locales.enable = mkDefault true;
        networking.enable = mkDefault true;
        nix.enable = mkDefault true;
        ssh.enable = mkDefault true;
        users.enable = mkDefault true;
        xserver.enable = mkDefault true;
      };
    })

    (mkIf cfg.enableBasic {
      my.system = {
        docker.enable = mkDefault true;
        fileSystem = {
          enable = mkDefault true;
          crypt = mkDefault false;
        };
        locales.enable = mkDefault true;
        networking.enable = mkDefault true;
        nix.enable = mkDefault true;
        ssh.enable = mkDefault true;
        users.enable = mkDefault true;
      };
    })
  ];
}
