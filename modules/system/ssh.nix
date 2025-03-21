{ config, lib, pkgs, ... }:

let
  inherit (builtins)
    any
    attrValues
    isList
    isAttrs
    map;
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    foldl
    recursiveUpdate;
  recursiveMerge = foldl recursiveUpdate { };
  cfg = config.my.system.ssh;

  uakModule = types.submodule {
    options = {
      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          username (default: root)
        '';
      };

      keys = mkOption {
        type = types.either (types.listOf types.str) (types.attrsOf types.str);
        default = { };
        example = literalExpression ''
          {
            "machine" = "ssh-rsa ...";
          }
        '';
        description = ''
          keys
        '';
      };
    };
  };

  defaultKeys = { };

  toList = x:
    if isList x then
      x
    else if isAttrs x then
      attrValues x
    else
      [ ];
in
{
  options.my.system.ssh = {
    enable = mkEnableOption "Basic ssh configuration";
    usersAndKeys = mkOption {
      type = types.listOf uakModule;
      default = [ ];
      description = ''
        user and its associated keys
      '';
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = if (any (x: x.user == "root") cfg.usersAndKeys) then "yes" else "no";
      };
      extraConfig = ''
        PubkeyAuthentication yes
        PermitEmptyPasswords no
        MaxAuthTries 3
      '';
    };

    users.users = recursiveMerge (map
      (u:
        { "${u.user}".openssh.authorizedKeys.keys = (toList u.keys) ++ (toList (defaultKeys.${u.user} or { })); }
      )
      cfg.usersAndKeys
    );
  };
}
