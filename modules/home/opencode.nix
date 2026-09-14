{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.opencode;
in
{
  options.my.home.opencode = {
    enable = mkEnableOption "Home opencode configuration";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings = {
        "$schema" = "https://opencode.ai/config.json";

        provider = {
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama (Remote)";

            options = {
              baseURL = "{env:OLLAMA_HOST}/v1";
            };

            models = {
              "{env:OLLAMA_DEFAULT_MODEL}" = {
                name = "{env:OLLAMA_DEFAULT_MODEL}";
              };
            };
          };
        };
      };
    };
  };
}
