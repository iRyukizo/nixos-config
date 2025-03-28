{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkOption
    mkIf
    types;

  cfg = config.my.home.nix;
in
{
  options.my.home.nix = {
    enable = mkEnableOption "Home nix configuration";
    gcCleanDuration = mkOption {
      type = types.str;
      default = "14d";
      description = ''
        remove files in nix-store old than value (default: 14d)
      '';
    };
  };

  config = mkIf cfg.enable {
    nix = {
      enable = true;
      package = mkDefault pkgs.nixStable;
      gc = {
        automatic = true;
        frequency = "weekly";
        options = "--delete-older-than " + cfg.gcCleanDuration;
        persistent = true;
      };

      registry = {
        config.flake = inputs.self;
      };

      settings = {
        warn-dirty = true;
        experimental-features = [ "nix-command" "flakes" ];
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://iryukizo.cachix.org"
        ];

        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "iryukizo.cachix.org-1:F7M4oyFKTfx6rJgI2MYB7FTXV+EL8c9BP3v1tDSNr08="
        ];
      };

      extraOptions = ''
        !include ${config.age.secrets."home/nix/extra-config".path}
      '';
    };
  };
}
