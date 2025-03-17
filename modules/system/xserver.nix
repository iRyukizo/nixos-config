{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.xserver;
in
{
  options.my.system.xserver = {
    enable = mkEnableOption "Basic xserver configuration";
    layout = mkOption {
      type = types.str;
      default = "us";
      description = ''
        overrideable layout (default: us);
      '';
    };
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.defaultSession = "none+i3";
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      xserver = {
        enable = true;
        xkb = {
          inherit (cfg) layout;
        };
        desktopManager.xterm.enable = false;
        windowManager.i3 = {
          package = pkgs.i3-gaps;
          enable = true;
          extraPackages = with pkgs; [
            dmenu
            i3status
            i3lock
          ];
        };
      };
    };
  };
}
