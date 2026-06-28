{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    xclip
    gotop
    wakeonlan

    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
  ];
}
