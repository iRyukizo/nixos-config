{ config, lib, ... }:

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
      type = types.enum [ "standard" "darwin" ];
      default = "standard";
      example = literalExpression ''standard'';
      description = ''
        Type of system (default: standard).
        Options: standard darwin
      '';
    };
  };

  config = mkIf cfg.enable {
    my.home = {
      direnv.enable = mkDefault true;
      git.enable = mkDefault true;
      go.enable = mkDefault true;
      gpg.enable = mkDefault true;
      ssh.enable = mkDefault true;
      tmux.enable = mkDefault true;
      vim.enable = mkDefault true;

      xdg.enable = mkDefault (cfg.type == "standard");

      zsh = {
        enable = mkDefault true;
      } // optionalAttrs (cfg.type == "darwin") {
        theme = "robbyrussell";
      };
    };
  };
}
