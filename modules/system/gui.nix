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

    # sound.enable = false;
    services.pipewire = {
      enable = true;

      extraConfig.pipewire."99-disable-bell" = {
        "context.properties"= {
          "module.x11.bell" = false;
        };
      };

      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;

    };
    # hardware.pulseaudio.enable = true;
  };
}
