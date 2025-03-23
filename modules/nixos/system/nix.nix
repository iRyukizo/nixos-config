{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.system.nix;
in
{
  options.my.system.nix = {
    enable = mkEnableOption "Nix module configuration";
    gcCleanDuration = mkOption {
      type = types.str;
      default = "14d";
      description = ''
        remove files in nix-store old than value (default: 14d)
      '';
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    nix = {
      package = pkgs.nixStable;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than " + cfg.gcCleanDuration;
        persistent = true;
      };

      registry = {
        config.flake = inputs.self;
      };

      settings = {
        warn-dirty = true;
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "@wheel" ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://iryukizo.cachix.org"
        ];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "iryukizo.cachix.org-1:F7M4oyFKTfx6rJgI2MYB7FTXV+EL8c9BP3v1tDSNr08="
        ];
      };
    };
  };
}
