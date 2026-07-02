{ config, lib, pkgs, ... }:

let
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    types;
  cfg = config.my.home.devenv;
in
{
  options.my.home.devenv = {
    enable = mkEnableOption "Home dev environment configuration";
    type = mkOption {
      type = types.enum [ "standard" "darwin" "remote" "wsl" ];
      default = "standard";
      example = literalExpression ''standard'';
      description = ''
        Type of system (default: standard).
        Options: standard darwin remote wsl
      '';
    };
  };

  config = mkIf cfg.enable {
    my.home = {
      bat.enable = mkDefault true;
      ctags = {
        enable = mkDefault true;
      };
      delta.enable = mkDefault true;
      direnv.enable = mkDefault true;

      fonts = {
        inherit (cfg) enable type;
      };

      fzf.enable = mkDefault true;
      git.enable = mkDefault true;
      go.enable = mkDefault true;
      gpg.enable = mkDefault true;
      man.enable = mkDefault true;
      nix.enable = mkDefault true;
      nix-index.enable = mkDefault true;
      ssh.enable = mkDefault true;
      tmux = {
        inherit (cfg) type;
        enable = mkDefault true;
      };
      vim = {
        inherit (cfg) type;

        enable = mkDefault true;
      };

      wsl.enable = mkDefault (cfg.type == "wsl");

      xdg = {
        enable = true;
        userDirsEnable = mkDefault (cfg.type != "darwin");
      };

      zsh = {
        enable = mkDefault true;
      } // optionalAttrs (cfg.type == "darwin" || cfg.type == "wsl") {
        theme = "robbyrussell";
      };
    };
  };
}
