{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf optional;
  cfg = config.my.system.fileSystem;
in
{
  options.my.system.fileSystem = {
    enable = mkEnableOption "Default EFI system (500M boot + all in ext4)";
    crypt = mkEnableOption "Use LUKS device and swap device" // { default = true; };
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

    boot.tmp.cleanOnBoot = true;

    boot.initrd.luks.devices.cryptroot = mkIf cfg.crypt {
      device = "/dev/disk/by-label/cryptroot";
      preLVM = true;
      allowDiscards = true;
    };
  };
}
