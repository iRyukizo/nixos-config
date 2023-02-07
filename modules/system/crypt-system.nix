{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.system.crypt;
in
{
  options.my.system.crypt = {
    enable = mkEnableOption "If system use my default encryption with LUKS";
  };

  config = mkIf cfg.enable {
    fileSystems."/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

    boot.initrd.luks.devices.cryptroot = {
      device = "/dev/disk/by-label/cryptroot";
      preLVM = true;
      allowDiscards = true;
    };
  };
}
