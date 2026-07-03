{ config, inputs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.nix-index;
in
{
  imports = [
    inputs.nix-index-database.homeModules.default
  ];

  options.my.home.nix-index = {
    enable = mkEnableOption "nix-index configuration";
  };

  config.programs = mkIf cfg.enable {
    nix-index-database.comma.enable = true;

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
