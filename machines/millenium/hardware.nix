{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      timeout = 15;
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "1920x1080";
      };
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Use the systemd-boot EFI boot loader.

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

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
