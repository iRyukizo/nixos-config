{ config, ... }:

{
  config.home.sessionVariables = {
    GITHUB_TOKEN = ''$(cat "${config.age.secrets."home/github/token".path}")'';
  };
}
