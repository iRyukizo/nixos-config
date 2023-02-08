{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.gui;
in
{
  options.my.system.gui = {
    enable = mkEnableOption "GUI configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dconf
      dbus
      networkmanagerapplet
    ];

    services.dbus.enable = true;
    programs = {
      gnupg.agent.enable = true;
      ssh.startAgent = true;
      nm-applet.enable = true;
    };

    sound.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
