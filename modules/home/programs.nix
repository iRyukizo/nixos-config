{ config
, inputs
, pkgs
, lib
, useGlobalPkgs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.my.home.programs;
in
{
  options.my.home.programs = {
    allowUnfree = mkEnableOption "allowUnfree";
  };

  config = {
    nixpkgs.config = mkIf (!useGlobalPkgs) {
      inherit (cfg) allowUnfree;
    };

    home.packages = with pkgs; [
      docker
      xclip
      wakeonlan
      fd

      inputs.agenix.packages."${stdenv.hostPlatform.system}".default
    ];
  };
}
