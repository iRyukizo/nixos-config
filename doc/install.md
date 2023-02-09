# NixOs Installation Guide

## Basic configuration for EFI system

```sh
DISK=/dev/sda # Use your own disk
gdisk "$DISK" # o/n(500M ef00)/n(rest 8300)/w
```

## Setup regular

If you don't want to use LUKS:

```sh
pvcreate "$DISK"2                   # Create a physical volume our disk
vgcreate vg "$DISK"2                # Create its own volume group
lvcreate -L 8G -n swap vg           # Create a logical volume for the swap using 8G
lvcreate -l '100%FREE' -n root vg   # Create a logical volume using all remaining space

mkfs.fat "$DISK"1
fatlabel "$DISK"1 boot                  # boot
mkfs.ext4 -L root /dev/vg/root          # root
mkswap -L swap /dev/vg/swap             # swap

mount /dev/vg/root /mnt         # Mount logical volume root into /mnt
mkdir -p /mnt/boot
mount "$DISK"1 /mnt/boot        # Mount boot partition int /mnt/boot

swapon /dev/vg/swap             # Activate swap
```

## Setup LUKS

If you want to use LUKS:

```sh
cryptsetup luksFormat "$DISK"2      # Format disk with LUKS
cryptsetup luksOpen "$DISK"2 root   # Open disk with LUKS

pvcreate /dev/mapper/root           # Create a physical volume for root
vgcreate vg /dev/mapper/root        # Create its own volume group
lvcreate -L 8G -n swap vg           # Create a logical volume for the swap using 8G
lvcreate -l '100%FREE' -n root vg   # Create a logical volume using all remaining space

mkfs.fat "$DISK"1
fatlabel "$DISK"1 boot                          # boot
mkfs.ext4 -L root /dev/vg/root                  # root
mkswap -L swap /dev/vg/swap                     # swap
cryptsetup config "$DISK"2 --label cryptroot    # cryptroot LUKS entry

mount /dev/vg/root /mnt         # Mount logical volume root into /mnt
mkdir -p /mnt/boot
mount "$DISK"1 /mnt/boot        # Mount boot partition int /mnt/boot

swapon /dev/vg/swap             # Activate swap
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
