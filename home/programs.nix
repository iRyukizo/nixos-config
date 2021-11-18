{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
    gotop
    nixpkgs-fmt

    # Fonts:
    (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
  ];

  fonts.fontconfig.enable = true;
}
