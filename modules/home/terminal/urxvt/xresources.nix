{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.my.home.terminal.urxvt.xresources;

  nord-xresources = pkgs.fetchFromGitHub {
    owner = "arcticicestudio";
    repo = "nord-xresources";
    rev = "ad8d70435ee0abd49acc7562f6973462c74ee67d";
    sha256 = "bjLQwYYkIMKgC68EGLkfWJWqJbiTIvTZ6bboGJNhS9E=";
  };
in
{
  options.my.home.terminal.urxvt.xresources = {
    enable = mkEnableOption "Urxvt xresources file";
  };


  config = mkIf cfg.enable {
    home.file.".Xresources-themes/nord.Xresources".source = nord-xresources + "/src/nord";

    xresources = {
      properties = {
        "Xft.dpi" = 140;
        "Xft.antialias" = true;
        "Xft.hinting" = true;
        "Xft.rgba" = "rgb";
        "Xft.autohint" = false;
        "Xft.hintstyle" = "hintfull";
        "Xft.lcdfilter" = "lcddefault";
      };
      extraConfig = ''
        #include "${config.home.homeDirectory}/.Xresources-themes/nord.Xresources"
      '';
    };
  };
}
