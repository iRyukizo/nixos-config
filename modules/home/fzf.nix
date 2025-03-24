{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.fzf;
in
{
  options.my.home.fzf = {
    enable = mkEnableOption "Home fzf configuration";
  };

  config = mkIf cfg.enable {
    programs.fzf.enable = true;

    home.sessionVariables = {
      FZF_DEFAULT_OPTS = "--color=fg:#e5e9f0,bg:-1,hl:#81a1c1 --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1 --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b";
    };
  };
}
