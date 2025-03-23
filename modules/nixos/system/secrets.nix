{ config, lib, inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    "${inputs.self}/modules/secrets"
  ];

  config.age.identityPaths = lib.mkDefault [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];
}
