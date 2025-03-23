{ config, inputs, lib, ... }:

{
  config.age = {
    secrets =
      let
        toName = lib.removeSuffix ".age";
        toSecret = name: { ... }: {
          file = ./. + "/${name}";
        };
        convertSecrets = n: v: lib.nameValuePair (toName n) (toSecret n v);
        secrets = import ./secrets.nix;
      in
      lib.mapAttrs' convertSecrets secrets;
  };
}
