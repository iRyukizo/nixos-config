{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    xclip
    gotop
    nixpkgs-fmt
    wakeonlan

    inputs.agenix.packages."${system}".default
  ];
}
