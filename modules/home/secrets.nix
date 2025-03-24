{ config, options, inputs, lib, pkgs, ... }:

let
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

  config.age.identityPaths = options.age.identityPaths.default ++ [
    "${config.home.homeDirectory}/.ssh/agenix"
  ];
}
