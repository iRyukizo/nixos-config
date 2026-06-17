{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkPackageOption optional;

  cfg = config.my.home.ctags;
in
{
  options.my.home.ctags = {
    enable = mkEnableOption "Home ctags configuration";
    package = mkPackageOption pkgs "universal-ctags" { };
    gtags = {
      enable = mkEnableOption "Home ctags with gtags support" // { default = true; };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ] ++ optional cfg.gtags.enable pkgs.global;

    home.file.".ctags.d/c.ctags".text = ''
      --languages=+C
      --C-kinds=+plx
      --recurse=yes
      --exclude=.git
      --exclude=.svn
      --exclude=build
      --exclude=dist
      --exclude=debug
      --exclude=*.js
      --exclude=vendor/*
      --exclude=db/*
      --exclude=log/*
      --exclude=node_modules/*
      --exclude=*.vim
      --exclude=*.swp
      --exclude=*.min.*
      --exclude=*.bak
      --exclude=*.pyc
      --exclude=*.sln
      --exclude=*.class
      --exclude=*.csproj
      --exclude=*.cache
      --exclude=*.dll
      --exclude=*.pdb
    '';
  };
}
