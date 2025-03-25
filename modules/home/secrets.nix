{ config, options, inputs, lib, pkgs, ... }:

let
  xdgCfg = config.my.home.xdg;
in
{
  imports = [
    inputs.agenix.homeManagerModules.age
    "${inputs.self}/modules/secrets"
  ];

  config.my.secrets = {
    enable = true;
    folderPrefix = {
      enable = true;
      prefix = "home/";
    };
  };

  config.age = {
    identityPaths = options.age.identityPaths.default ++ [
      "${config.home.homeDirectory}/.ssh/agenix"
    ];

    # We want a concrete path cause agenix use shell variables and therefore
    # not expanded, so it's difficult to use in non shell configuration.
    # Since XDG RUNTIME DIR is not user set, better to use something else.
    secretsDir =
      if xdgCfg.enable
      then
        "${config.xdg.dataHome}/agenix"
      else
        options.age.secretsDir.default;
  };
}
