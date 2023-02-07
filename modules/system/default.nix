{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.system;
in
{
  imports = [
    ./crypt-system.nix
    ./locales.nix
    ./nix.nix
    ./users.nix
    ./xserver.nix
  ];

  options.my.system = {
    enableDefault = mkEnableOption "Enable all default options";
  };

  config = mkIf cfg.enableDefault {
    my.system = {
      crypt.enable = mkDefault true;
      locales.enable = mkDefault true;
      nix.enable = mkDefault true;
      users.enable = mkDefault true;
      xserver.enable = mkDefault true;
    };
  };
}
