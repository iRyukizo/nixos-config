{ config, ... }:

{
  config.home.sessionVariables = {
    GITHUB_TOKEN = ''$(cat "${config.age.secrets."home/github/token".path}")'';
    LICHESS_BOT_TOKEN = ''$(cat "${config.age.secrets."home/lichess/token".path}")'';
  };
}
