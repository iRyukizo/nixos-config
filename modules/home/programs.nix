{ inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    docker
    xclip
    gotop
    wakeonlan

    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
  ];
}
