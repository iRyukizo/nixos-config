{ config, lib, inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    "${inputs.self}/modules/secrets"
  ];

  config.my.secrets = {
    enable = true;
    folderPrefixes = {
      enable = true;
      prefixes = [ "nixos/" ];
    };
  };

  config.age.identityPaths = lib.mkDefault [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];
}
