{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption types;
  inherit (config.age) secrets;

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
    users = {
      mutableUsers = false;

      users = {
        root.hashedPasswordFile = secrets."users/root/hashed-password".path;

        "${cfg.name}" = {
          hashedPasswordFile = secrets."users/ryuki/hashed-password".path;
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
    };
  };
}
