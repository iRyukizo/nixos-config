{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    xclip
    gotop
    nixpkgs-fmt
    wakeonlan

    inputs.agenix.packages."${system}".default
  ];
}
