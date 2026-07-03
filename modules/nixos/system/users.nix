{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
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
    uid = mkOption {
      type = with types; nullOr int;
      default = null;
      description = ''
        The account UID. If the UID is null, a free UID is picked on activation.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    users = {
      mutableUsers = false;

      users = {
        root.hashedPasswordFile = secrets."nixos/users/root/hashed-password".path;

        "${cfg.name}" = {
          inherit (cfg) uid;

          hashedPasswordFile = secrets."nixos/users/ryuki/hashed-password".path;
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
