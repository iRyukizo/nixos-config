{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption optionals;

  cfg = config.my.system.documentation;
in
{
  options.my.system.documentation = {
    enable = mkEnableOption "Documentation integration";
    dev.enable = mkEnableOption "Documentation aimed at developers" // { default = true; };
    info.enable = mkEnableOption "`info` command" // { default = true; };
    man = {
      enable = mkEnableOption "Documentation aimed at developers" // { default = true; };
      linux = mkEnableOption "Linux man pages (section 2 & 3)" // { default = true; };
      cache = {
        enable = mkEnableOption "Generate man caches" // { default = true; };
      };
    };
    nixos.enable = mkEnableOption "NixOS documentation" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    documentation = {
      enable = true;
      dev.enable = cfg.dev.enable;
      info.enable = cfg.info.enable;
      man = {
        enable = cfg.man.enable;
        cache = {
          inherit (cfg.man.cache) enable;
        };
      };
      nixos.enable = cfg.nixos.enable;
    };

    environment.systemPackages = with pkgs; optionals cfg.man.linux [
      man-pages
      man-pages-posix
    ];
  };
}
