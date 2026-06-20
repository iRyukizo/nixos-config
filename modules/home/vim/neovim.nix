{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.my.home.vim;
  vimEnabled = cfg.programs.vim;
in
{
  config = mkIf (cfg.enable && cfg.programs.neovim) {
    programs.neovim = {
      enable = true;
      defaultEditor = !vimEnabled;

      viAlias = !vimEnabled;
      vimAlias = !vimEnabled;
      vimdiffAlias = !vimEnabled;
    };
  };
}
