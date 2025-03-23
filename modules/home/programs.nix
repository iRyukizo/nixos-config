{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    gotop
    nixpkgs-fmt

    inputs.agenix.packages."${system}".default
  ];
}
