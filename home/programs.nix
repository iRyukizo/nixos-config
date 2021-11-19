{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
    gotop
    nixpkgs-fmt
    arandr
    xclip

    # Fonts:
    meslo-lgs-nf
  ];

  fonts.fontconfig.enable = true;
}
