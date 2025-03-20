{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.my.home.macos;
in
{
  options.my.home.macos = {
    enable = mkEnableOption "Home macos environment configuration";
  };

  config = mkIf cfg.enable {
    my.home = {
      git.enable = mkDefault true;
      go.enable = mkDefault true;
      gpg.enable = mkDefault true;
      tmux.enable = mkDefault true;
      vim.enable = mkDefault true;
      zsh = {
        enable = mkDefault true;
        theme = "robbyrussell";
      };
    };
  };
}
