{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    xclip
    gotop
    nixpkgs-fmt

    inputs.agenix.packages."${system}".default
  ];
}
