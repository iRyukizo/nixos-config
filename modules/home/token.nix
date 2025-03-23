{ config, ... }:

{
  config.home.sessionVariables = {
    GITHUB_TOKEN = ''$(cat "${config.age.secrets."github/token".path}")'';
  };
}
