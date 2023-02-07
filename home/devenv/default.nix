{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.home.devenv;
in
{
  options.my.home.devenv = {
    enable = mkEnableOption "Home dev environment configuration";
  };

  config = mkIf cfg.enable {
    my.home = {
      git.enable = mkDefault true;
      go.enable = mkDefault true;
      vim.enable = mkDefault true;
      xdg.enable = mkDefault true;
      zsh.enable = mkDefault true;
    };
  };
}
