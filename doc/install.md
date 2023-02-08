# NixOs Installation Guide

## Basic configuration for EFI system

```sh
DISK=/dev/sda # Use your own disk
gdisk "$DISK" # o/n(500M ef00)/n(rest 8300)/w
```

### Setup regular

If you don't want to use LUKS:

```sh
mkfs.fat "$DISK"1
fatlabel "$DISK"1 boot                  # boot
mkfs.ext4 -L root "$DISK"2              # root

mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=8388608    # 8G swap file
chmod 600 /mnt/.swapfile
mkswap /mnt/.swapfile
swapon /mnt/.swapfile
```

### Setup LUKS

If you want to use LUKS:

```sh
cryptsetup luksFormat "$DISK"2
cryptsetup luksOpen "$DISK"2 root
pvcreate /dev/mapper/root           # Create a physical volume for root
vgcreate vg /dev/mapper/root        # Create its own volume group
lvcreate -L 8G -n swap vg           # Create a logical volume for the swap using 8G
lvcreate -l '100%FREE' -n root vg   # Create a logical volume using all remaining space
```

#### Setup and label

```sh
mkfs.fat "$DISK"1
fatlabel "$DISK"1 boot                          # boot
mkfs.ext4 -L root /dev/vg/root                  # root
mkswap -L swap /dev/vg/swap                     # swap
cryptsetup config "$DISK"2 --label cryptroot    # cryptroot LUKS entry

mount /dev/vg/root /mnt
mkdir -p /mnt/boot
mount "$DISK"1 /mnt/boot

swapon /dev/vg/swap
```

## Install

Watch out for hardware configuration:

```sh
nixos-generate-config --root /mnt
```

Use flake to build:

```sh
nixos-insall --flake .#machine
```

Don't forget to setup password for users and root.
