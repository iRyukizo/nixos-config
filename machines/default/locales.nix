{ ... }:

{
  i18n = {
    # defaultLocale = "en_US.UTF-8"; # en_US.UTF-8 is already default
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
    };
  };
}
