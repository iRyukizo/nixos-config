{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.delta;
in
{
  options.my.home.delta = {
    enable = mkEnableOption "Home delta configuration";
  };

  config.programs.delta = mkIf cfg.enable {
    enable = true;

    enableGitIntegration = true;
    options = {
      features = "diff-highlight decorations";
      syntax-theme = "Nord";
      blame-code-style = "syntax";
      blame-format = "{author:<18} {commit:<6} {timestamp:>15}";
      blame-palette = "#2E3440 #3B4252 #434C5E";

      decorations = {
        keep-plus-minus-markers = true;
        paging = "always";
      };
    };
  };
}
