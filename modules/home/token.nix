{ config, lib, ... }:

let
  secretsCfg = config.my.secrets;
in
{
  config.home.sessionVariables = lib.mkIf secretsCfg.enable {
    GITHUB_TOKEN = ''$(cat "${config.age.secrets."home/github/token".path}")'';
    LICHESS_BOT_TOKEN = ''$(cat "${config.age.secrets."home/lichess/token".path}")'';
  };
}
