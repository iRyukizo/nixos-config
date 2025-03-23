{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption types;
  cfg = config.my.system.locales;
in
{
  options.my.system.locales = {
    enable = mkEnableOption "Locale configuration";
    lang = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = ''
      '';
    };
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = cfg.lang;
      extraLocaleSettings = {
        LC_ALL = cfg.lang;
        LANG = cfg.lang;
      };
    };
  };
}
