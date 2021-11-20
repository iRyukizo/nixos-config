{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
    gotop
    nixpkgs-fmt
    xclip
    discord

    # Fonts:
    meslo-lgs-nf
  ];

  fonts.fontconfig.enable = true;
}
