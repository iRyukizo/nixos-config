{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gotop
    nixpkgs-fmt
  ];
}
