{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.packages.core;
in
{
  options.my.packages.core = {
    enable = mkEnableOption "Core packages";
  };

  config = mkIf cfg.enable {
    programs.vim.enable = true;

    environment.systemPackages = with pkgs; [
      file
      git
      htop
      man-pages
      man-pages-posix
      tmux
      tree
      usbutils
      util-linux
      unzip
      vim
      wakeonlan
      wget
      zip

      inputs.agenix.packages."${system}".default
    ];
  };
}
