{ config, pkgs, ... }:

{
  imports = [
    # Machine own config
    ./mothership
    ./mothership/hardware.nix

    # Inherit default config
    ./default/crypt-system.nix
    ./default/locales.nix
    ./default/nix.nix
    ./default/programs.nix
    # ./default/users.nix
    ./default/xserver.nix
  ];

  system.stateVersion = "21.05";
}
