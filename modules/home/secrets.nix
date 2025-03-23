{ config, options, inputs, lib, pkgs, ... }:

let
in
{
  imports = [
    inputs.agenix.homeManagerModules.age
    "${inputs.self}/modules/secrets"
  ];

  config.age.identityPaths = options.age.identityPaths.default ++ [
    "${config.home.homeDirectory}/.ssh/agenix"
  ];
}
