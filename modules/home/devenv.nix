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
      type = types.enum [ "standard" "darwin" "remote" ];
      default = "standard";
      example = literalExpression ''standard'';
      description = ''
        Type of system (default: standard).
        Options: standard darwin remote
      '';
    };
  };

  config = mkIf cfg.enable {
    my.home = {
      bat.enable = mkDefault true;
      direnv.enable = mkDefault true;

      fonts = {
        inherit (cfg) enable type;
      };

      fzf.enable = mkDefault true;
      git.enable = mkDefault true;
      go.enable = mkDefault true;
      gpg.enable = mkDefault true;
      nix.enable = mkDefault true;
      ssh.enable = mkDefault true;
      tmux = {
        inherit (cfg) type;
        enable = mkDefault true;
      };
      vim.enable = mkDefault true;

      xdg = {
        enable = true;
        userDirsEnable = mkDefault (cfg.type != "darwin");
      };

      zsh = {
        enable = mkDefault true;
      } // optionalAttrs (cfg.type == "darwin") {
        theme = "robbyrussell";
      };
    };
  };
}
