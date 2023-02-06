{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    xclip
    discord
    scrot

    faba-icon-theme
    gnome-icon-theme
    betterlockscreen
    lm_sensors

    # Fonts:
    meslo-lgs-nf
    font-awesome
    siji
  ];

  fonts.fontconfig.enable = true;
}
