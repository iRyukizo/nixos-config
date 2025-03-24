{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.fzf;
in
{
  options.my.home.fzf = {
    enable = mkEnableOption "Home fzf configuration";
  };

  config.programs.fzf = mkIf cfg.enable {
    enable = true;
    enableZshIntegration = true;

    colors = {
      fg = "#e5e9f0";
      bg = "-1";
      hl = "#81a1c1";
      "fg+" = "#e5e9f0";
      "bg+" = "#3b4252";
      "hl+" = "#81a1c1";
      info = "#eacb8a";
      prompt = "#bf6069";
      pointer = "#b48dac";
      marker = "#a3be8b";
      spinner = "#b48dac";
      header = "#a3be8b";
    };
  };
}
