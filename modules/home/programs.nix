{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    xclip
    gotop
    stylua
    nixpkgs-fmt
    wakeonlan

    inputs.agenix.packages."${system}".default
  ];
}
