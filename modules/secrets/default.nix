{ config, inputs, lib, ... }:

let
  inherit (lib) filterAttrs literalExpression mkEnableOption mkIf mkOption types;
  inherit (lib.strings) hasPrefix;

  prefixModule = types.submodule {
    options = {
      enable = mkEnableOption "Enable folder prefixing";
      prefix = mkOption {
        type = types.str;
        default = "";
        example = literalExpression ''/home'';
        description = ''
          folder prefix to look for age files. (default: "")
        '';
      };
    };
  };

  cfg = config.my.secrets;
in
{
  options.my.secrets = {
    enable = mkEnableOption "secrets configuration" // { default = true; };
    folderPrefix = mkOption {
      type = prefixModule;
      default = { enable = false; prefix = ""; };
      description = ''
        Either we need to look for certain kind of files.
      '';
    };
  };

  config.age = lib.mkIf cfg.enable {
    secrets =
      let
        toName = lib.removeSuffix ".age";
        toSecret = name: { ... }: {
          file = ./. + "/${name}";
        };
        convertSecrets = n: v: lib.nameValuePair (toName n) (toSecret n v);
        secrets = import ./secrets.nix;
        secretsSet = lib.mapAttrs' convertSecrets secrets;
        prefixSecretsSet =
          if (cfg.folderPrefix.enable)
          then
            (filterAttrs (n: v: (hasPrefix cfg.folderPrefix.prefix n)) secretsSet)
          else
            secretsSet;
      in
      prefixSecretsSet;
  };
}
