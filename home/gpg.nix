{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.gpg;
in
{
  options.my.home.gpg = {
    enable = mkEnableOption "Home gpg configuration";
  };

  config = mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };
}
