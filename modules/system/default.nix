{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.system;
in
{
  imports = [
    ./crypt-system.nix
    ./nix.nix
    ./xserver.nix
  ];

  options.my.system = {
    enableDefault = mkEnableOption "Enable all default options";
  };

  config = mkIf cfg.enableDefault {
    my.system = {
      crypt.enable = mkDefault true;
      nix.enable = mkDefault true;
      xserver.enable = mkDefault true;
    };
  };
}
