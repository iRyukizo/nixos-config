{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption types;
  cfg = config.my.system.users;
in
{
  options.my.system.users = {
    enable = mkEnableOption "Users configuration";
    name = mkOption {
      type = types.str;
      default = "ryuki";
      description = ''
        username (default: ryuki)
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users."${cfg.name}" = {
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
      isNormalUser = true;
      extraGroups = [
        "audio"
        "docker"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };
}
