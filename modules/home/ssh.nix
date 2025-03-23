{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.home.ssh;
in
{
  options.my.home.ssh = {
    enable = mkEnableOption "Home ssh configuration";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";

      includes = [
        "config.local"
      ];
    };
  };
}
